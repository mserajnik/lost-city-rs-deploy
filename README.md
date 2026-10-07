# lost-city-rs-deploy

[![Lint status][badge-lint-status]][badge-lint-status-url]
[![Build status][badge-build-status]][badge-build-status-url]

---

> [!WARNING]
> lost-city-rs-deploy was relaunched on 2026-10-04 with major changes that
> require adjusting your configuration. If you used it before this date, work
> through the [breaking changes](docs/breaking-changes.md) before you update.

---

lost-city-rs-deploy is a Docker-based solution for running
[Lost City RS][lost-city-rs]. It offers:

- __Prebuilt Docker images for both `amd64` and `arm64`, built with GitHub
  Actions__: simply pull the image for your architecture and get started.
- __The ability to run any supported version of Lost City RS__: prebuilt images
  for all fully playable versions, from `225` to `274`, are provided.
- __Automated database migrations__: when you pull the latest Docker image and
  re-create the container, the migrations are applied automatically to keep
  your database up to date at all times.

> [!NOTE]
> The Docker images are built daily when Lost City RS has had new commits since
> the last build. Additionally, every Monday, the latest images are rebuilt to
> keep their system packages up to date, even if Lost City RS itself has not
> changed.

## Quick start

The steps below get a local installation running quickly, for playing on the
same machine. You need [Docker][docker] with [Docker Compose][docker-compose].

1. Clone the repository and copy the example Compose file:

   ```sh
   git clone https://github.com/mserajnik/lost-city-rs-deploy.git
   cd lost-city-rs-deploy
   cp compose.yaml.example compose.yaml
   ```

2. Adjust your `compose.yaml`: set the image of the version you want, as the
   [versions section](docs/usage.md#versions) lists, and `TZ` to your time
   zone. On Linux, set `LOST_CITY_RS_UID` and `LOST_CITY_RS_GID` to your user's
   UID and GID. The [Docker Compose reference](docs/compose.md) explains every
   setting.

3. Start Lost City RS:

   ```sh
   docker compose up -d
   ```

   Then open `http://localhost:8888/rs2.cgi` in your browser to access the web
   client.

For the full instructions, see the [usage documentation](docs/usage.md).

### Using a coding agent

A coding agent such as [Claude Code][claude-code] or [Codex][codex] can walk
you through the setup. Try a prompt like this one:

```text
Help me install and set up https://github.com/mserajnik/lost-city-rs-deploy.
First, clone the repository and read the README and every file under docs/
carefully.
Then guide me through the installation process step by step, following the
documentation closely.
Do as much of the setup yourself as you safely can so that I only have to step
in when a manual action or personal preference is required.
Ask me about my preferences whenever a choice has to be made, explain the
relevant options clearly, and tailor your instructions to the OS I am using.
Assume that I am not familiar with Lost City RS or Docker and that I have not
read the documentation myself.
For steps that I need to perform manually, give me clear instructions and exact
commands where appropriate.
Do not assume user-facing choices such as the Lost City RS version or
networking-related preferences.
Ask me whenever the documentation presents a meaningful choice.
For settings that the documentation indicates should generally be left alone,
keep the defaults unless I explicitly ask for something else.
Do not change settings that the documentation indicates should not be changed.
```

The prompt that works best depends on the agent and the model.

> [!CAUTION]
> You use coding agents at your own risk, and you are responsible for the
> access you give them. The maintainer of this project is not liable for any
> damage or data loss they cause. Take precautions such as sandboxed access and
> limited permissions, and do not run them with `--yolo` or similar options
> that bypass their safety checks.

## Documentation

- [Usage](docs/usage.md): the scope of the setup, choosing images, and running
  and updating Lost City RS.
- [Docker Compose reference](docs/compose.md): every setting in the Compose
  file.
- [Breaking changes](docs/breaking-changes.md): the changes you have to act on
  when you update.

## Maintainer

[Michael Serajnik][maintainer]

## Contribute

You are welcome to help out!

[Open an issue][issues] or [make a pull request][pull-requests].

## Licenses

- [`AGPL-3.0-or-later`][license-agpl-3.0-or-later] (Code)
- [`CC-BY-SA-4.0`][license-cc-by-sa-4.0] (Documentation and issue templates)
- [`CC0-1.0`][license-cc0-1.0] (Configuration files)

This project follows the [REUSE specification][reuse-spec].

## Disclaimer

lost-city-rs-deploy is an independent, community-made Docker setup for the
open-source [Lost City RS][lost-city-rs] project. It is not affiliated with,
endorsed by, or sponsored by Jagex Limited, and it is not an official Lost City
RS project.

It is intended for private, non-commercial use only and comes with no warranty.

[badge-build-status]: https://github.com/mserajnik/lost-city-rs-deploy/actions/workflows/build-docker-images.yaml/badge.svg
[badge-build-status-url]: https://github.com/mserajnik/lost-city-rs-deploy/actions/workflows/build-docker-images.yaml
[badge-lint-status]: https://github.com/mserajnik/lost-city-rs-deploy/actions/workflows/lint.yaml/badge.svg
[badge-lint-status-url]: https://github.com/mserajnik/lost-city-rs-deploy/actions/workflows/lint.yaml
[claude-code]: https://www.anthropic.com/product/claude-code
[codex]: https://openai.com/codex
[docker]: https://docs.docker.com/get-docker/
[docker-compose]: https://docs.docker.com/compose/install/
[issues]: https://github.com/mserajnik/lost-city-rs-deploy/issues
[license-agpl-3.0-or-later]: LICENSES/AGPL-3.0-or-later.txt
[license-cc-by-sa-4.0]: LICENSES/CC-BY-SA-4.0.txt
[license-cc0-1.0]: LICENSES/CC0-1.0.txt
[lost-city-rs]: https://github.com/LostCityRS
[maintainer]: https://github.com/mserajnik
[pull-requests]: https://github.com/mserajnik/lost-city-rs-deploy/pulls
[reuse-spec]: https://reuse.software/spec/
