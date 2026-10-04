#!/bin/sh

# SPDX-FileCopyrightText: 2025-2026 Michael Serajnik <https://github.com/mserajnik>
# SPDX-License-Identifier: AGPL-3.0-or-later

# Checks only the deploy version, so an update can test the new image before it
# re-creates the container.

set -eu

# shellcheck source=docker/check-deploy-version.sh
. /usr/local/lib/lost-city-rs-deploy/check-deploy-version.sh

echo "[lost-city-rs-deploy]: This image expects 'LOST_CITY_RS_DEPLOY_VERSION=$expected_deploy_version', and the variable matches."
