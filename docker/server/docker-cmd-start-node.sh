#!/bin/sh

# SPDX-FileCopyrightText: 2025-2026 Michael Serajnik <https://github.com/mserajnik>
# SPDX-License-Identifier: AGPL-3.0-or-later

# Starts Lost City RS from version `274` on, under Node.js. The engine reads
# its configuration from `data/config/world.json` and generates that file from
# `.env` when it is missing. Writing `.env` from the environment on every start
# keeps the Compose file the source of truth.

set -eu

# shellcheck source=docker/check-deploy-version.sh
. /usr/local/lib/lost-city-rs-deploy/check-deploy-version.sh
# shellcheck source=docker/server/drop-privileges.sh
. /usr/local/lib/lost-city-rs-deploy/drop-privileges.sh

cd /opt/lost-city-rs/engine

echo "[lost-city-rs-deploy]: Generating world configuration from environment variables."

rm -f data/config/world.json

cat >.env <<EOF
EASY_STARTUP=${EASY_STARTUP}
WEBSITE_REGISTRATION=${WEBSITE_REGISTRATION}
WEB_PORT=${WEB_PORT}
NODE_MEMBERS=${NODE_MEMBERS:-true}
NODE_XPRATE=${NODE_XPRATE:-1}
NODE_PRODUCTION=${NODE_PRODUCTION}
NODE_DEBUG=${NODE_DEBUG}
LOGIN_SERVER=${LOGIN_SERVER}
LOGIN_HOST=${LOGIN_HOST}
LOGIN_PORT=${LOGIN_PORT}
FRIEND_SERVER=${FRIEND_SERVER}
FRIEND_HOST=${FRIEND_HOST}
FRIEND_PORT=${FRIEND_PORT}
LOGGER_SERVER=${LOGGER_SERVER}
LOGGER_HOST=${LOGGER_HOST}
LOGGER_PORT=${LOGGER_PORT}
DB_BACKEND=${DB_BACKEND}
EOF

npm run sqlite:migrate

exec node_modules/.bin/tsx src/app.ts
