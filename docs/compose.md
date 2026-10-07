# Docker Compose reference

Your `compose.yaml` starts as a copy of the example Compose file,
[`compose.yaml.example`](../compose.yaml.example).

For each service, the [services section](#services) below has a table of its
keys, such as `image` and `volumes`, and, if it has any, a table of its
environment variables with their default values. The sections after it explain
some settings in more detail.

> [!WARNING]
> Where a setting needs a specific value for the setup to work, its description
> says so. Changes to such settings are unsupported and can break the setup.

## Services

### `app`

The `app` service runs Lost City RS.

| Key           | Description                                                                                                                                                                                                                                                                                                                                                       |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `image`       | The Docker image. Its tag indicates the game version, such as `ghcr.io/mserajnik/lost-city-rs:274`. The [versions section](usage.md#versions) lists the available images. The anchor `&app-image` passes the image on to `check-deploy-version`, and has to stay.                                                                                                 |
| `restart`     | With `unless-stopped`, Docker restarts the container automatically when it exits and when Docker itself starts, unless you stopped it manually.                                                                                                                                                                                                                   |
| `healthcheck` | Sets the container's status to `healthy` or `unhealthy`, to indicate whether something is wrong. The port in `test` has to match `WEB_PORT`. `start_period: 5m` covers the first minutes after a start, when the engine applies its migrations and packs its cache, and prevents a failing healthcheck during that period from setting the status to `unhealthy`. |
| `ports`       | The port mapping of the web client. To use another port on the host, change the host port number, left of the colon. The container port number, right of the colon, has to match `WEB_PORT`.                                                                                                                                                                      |
| `volumes`     | `storage/database/` holds the SQLite database, and `storage/data/players/` holds the player saves. The paths inside the container, right of the colon, have to stay as they are.                                                                                                                                                                                  |
| `environment` | The variables in the table below. The anchor `&app-environment` passes them on to `check-deploy-version`, and has to stay.                                                                                                                                                                                                                                        |

The `environment` of `app` has:

| Variable                      | Default   | Description                                                                                                                 |
| ----------------------------- | --------- | --------------------------------------------------------------------------------------------------------------------------- |
| `LOST_CITY_RS_DEPLOY_VERSION` | Required  | The number that the image checks on startup. See the [`LOST_CITY_RS_DEPLOY_VERSION` section](#lost_city_rs_deploy_version). |
| `TZ`                          | `Etc/UTC` | The time zone of the service, such as `Europe/Vienna`. You usually want to set this to your host's time zone.               |
| `LOST_CITY_RS_UID`            | `1000`    | The UID the server runs as. See the [user and group section](#user-and-group).                                              |
| `LOST_CITY_RS_GID`            | `1000`    | The GID the server runs as. See the [user and group section](#user-and-group).                                              |
| `WEB_PORT`                    | `8888`    | The port of the web client inside the container.                                                                            |
| `NODE_MEMBERS`                | `true`    | With `true`, it enables members features for the world.                                                                     |
| `NODE_XPRATE`                 | `1`       | The experience rate multiplier, such as `2` for twice the experience.                                                       |

### `check-deploy-version`

The `check-deploy-version` service checks whether you have to make adjustments
for a breaking change, as the [updating section](usage.md#updating) describes.

| Key           | Description                                                                                                                                               |
| ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `image`       | The image of `app`, through the alias `*app-image`, so it checks the image that `app` runs. It has to stay as it is.                                      |
| `profiles`    | With `['tools']`, `docker compose up` does not start the service, because it only runs on demand, to check for breaking changes. It has to stay as it is. |
| `entrypoint`  | Runs the check. It has to stay as it is.                                                                                                                  |
| `environment` | The environment of `app`, through the alias `*app-environment`. It has to stay as it is.                                                                  |

## `LOST_CITY_RS_DEPLOY_VERSION`

The image expects a specific number in `LOST_CITY_RS_DEPLOY_VERSION` and
refuses to start with any other value, a missing one included. When a new image
changes something that you have to act on, the number it expects increases by
one, and the [breaking changes documentation](breaking-changes.md) lists what
to change before you raise the number in your `compose.yaml` to match.

## User and group

The container starts as root and switches to a user with the UID and GID from
`LOST_CITY_RS_UID` and `LOST_CITY_RS_GID`. Files the server writes belong to
that user. Setting `user` instead stops the container with an error.

On Linux, set both to the owner of `storage/database/` and
`storage/data/players/`, which is usually your own user. Changing
`LOST_CITY_RS_UID` and `LOST_CITY_RS_GID` once the server has run also requires
changing the owner of the directories on the host, for example with
`sudo chown -R 1001:1001 storage`. Without that, the server can no longer write
to the files it created.

On macOS, Docker maps the owner of bind-mounted files, and the default values
work. On Windows, an installation on a Windows drive behaves the same way. An
installation inside the Linux file system of WSL 2 follows the rules for Linux.
