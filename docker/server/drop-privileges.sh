# shellcheck shell=sh

# SPDX-FileCopyrightText: 2025-2026 Michael Serajnik <https://github.com/mserajnik>
# SPDX-License-Identifier: AGPL-3.0-or-later

# Assigns the UID and GID from `LOST_CITY_RS_UID` and `LOST_CITY_RS_GID` to the
# `lost-city-rs` user, then runs the sourcing wrapper again as that user.

if [ "$(id -u)" = "0" ]; then
  uid="${LOST_CITY_RS_UID:-1000}"
  gid="${LOST_CITY_RS_GID:-1000}"

  # `usermod` also changes the owner of the files in the home directory. The
  # bind mounts keep their owner, so the UID and GID have to match it.
  if [ "$(id -g lost-city-rs)" != "$gid" ]; then
    # `-o` accepts a GID that a group in the image already uses, such as `100`.
    groupmod -o -g "$gid" lost-city-rs
  fi
  if [ "$(id -u lost-city-rs)" != "$uid" ]; then
    usermod -u "$uid" lost-city-rs
  fi

  # The engine writes its caches and generated configuration into these paths.
  # The rest of the tree keeps its owner.
  find /opt/lost-city-rs/engine -maxdepth 0 \( \! -user "$uid" -o \! -group "$gid" \) -exec chown "$uid:$gid" {} +
  find /opt/lost-city-rs/content/pack /opt/lost-city-rs/engine/data/config \
    /opt/lost-city-rs/engine/data/pack /opt/lost-city-rs/engine/data/symbols \
    /opt/lost-city-rs/engine/node_modules/.cache \
    \( \! -user "$uid" -o \! -group "$gid" \) -exec chown -h "$uid:$gid" {} +

  export HOME=/home/lost-city-rs LOST_CITY_RS_PRIVILEGES_DROPPED=1
  exec setpriv --reuid="$uid" --regid="$gid" --clear-groups --inh-caps=-all "$0" "$@"
elif [ -z "${LOST_CITY_RS_PRIVILEGES_DROPPED:-}" ]; then
  echo "[lost-city-rs-deploy]: ERROR: The container has to start as root. Replace 'user' with 'LOST_CITY_RS_UID' and 'LOST_CITY_RS_GID' in its service in your 'compose.yaml', as 'compose.yaml.example' shows." >&2
  exit 1
fi
