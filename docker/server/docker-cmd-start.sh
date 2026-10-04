#!/bin/sh

# SPDX-FileCopyrightText: 2025-2026 Michael Serajnik <https://github.com/mserajnik>
# SPDX-License-Identifier: AGPL-3.0-or-later

# Starts Lost City RS.

set -eu

# shellcheck source=docker/check-deploy-version.sh
. /usr/local/lib/lost-city-rs-deploy/check-deploy-version.sh
# shellcheck source=docker/server/drop-privileges.sh
. /usr/local/lib/lost-city-rs-deploy/drop-privileges.sh

cd /opt/lost-city-rs/engine

bun sqlite:migrate

# Skip upstream's `start` script, which runs `bun install` first.
exec bun run src/app.ts
