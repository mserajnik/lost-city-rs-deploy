# Usage

With lost-city-rs-deploy, you choose a Docker image for a Lost City RS version,
run it with Docker Compose, and update it to get the latest Lost City RS
changes. The sections below describe each step in detail, along with the scope
of the setup. The [Docker Compose reference](compose.md) explains the settings.

## Scope

The setup runs a single world, with SQLite as the database, and players connect
through the web client. The web client also creates the accounts, so to disable
public access, put access control in front of it, such as a reverse proxy with
HTTP basic authentication. Other setups may work, but they are untested and
unsupported.

## Choosing images

### Versions

lost-city-rs-deploy builds an image for each version of Lost City RS that is
fully playable, each from that version's branches of
[LostCityRS/Engine-TS][lost-city-rs-engine] and
[LostCityRS/Content][lost-city-rs-content]:

| Version | Image                                  |
| ------- | -------------------------------------- |
| `274`   | `ghcr.io/mserajnik/lost-city-rs:274`   |
| `254`   | `ghcr.io/mserajnik/lost-city-rs:254`   |
| `245.2` | `ghcr.io/mserajnik/lost-city-rs:245.2` |
| `244`   | `ghcr.io/mserajnik/lost-city-rs:244`   |
| `225`   | `ghcr.io/mserajnik/lost-city-rs:225`   |

More images are added as more versions become fully playable.

### Pinning a specific Lost City RS build

Each image also has a tag with the two commits it contains, as 7-character
prefixes, such as `274-engine.1d25566-content.65b754f`. Use such a tag to pin
your installation to a specific build.

Since the Docker images are generally built only once a day, there is likely no
build for every single Lost City RS commit combination. Older images are
deleted automatically after 14 days, so do not rely on the registry keeping a
specific image after you first pulled it. If you need images based on specific
Lost City RS commits, you can build them yourself. The registry lists the
current [images][image-lost-city-rs-versions].

## Running Lost City RS

To start Lost City RS, run:

```sh
docker compose up -d
```

Then open `http://localhost:8888/rs2.cgi` in your browser to access the web
client. From there, you can put a reverse proxy in front of it, as the
[scope section](#scope) describes.

To stop Lost City RS, run:

```sh
docker compose down
```

## Updating

To update, pull the new image and check it:

```sh
docker compose pull
docker compose run --rm check-deploy-version
```

When the new image needs configuration adjustments due to a
[breaking change](breaking-changes.md), the check fails and names the version
it expects. Make those adjustments first.

If the check passes and prints that the variable matches, re-create the
container:

```sh
docker compose up -d
```

If you pinned your installation to a specific build, the update only takes
effect once you set a newer tag.

> [!WARNING]
> Switching to another game version by changing the image tag is unsupported.
> The versions apply different database migrations, so the switch can leave
> your data unusable. To start a new installation with another version, back up
> `storage/` first, and then follow the
> [quick start section](../README.md#quick-start) in a new clone of this
> repository.

### Updating your clone

Update your clone of this repository regularly with `git pull`, and always
before you apply a breaking change, so you have the updated example Compose
file to compare with.

> [!IMPORTANT]
> The relaunch replaced the history of this repository, so `git pull` fails in
> a clone from before 2026-10-04. To update such a clone once, run `git fetch`
> and then `git reset --hard origin/master` in it. That keeps your
> `compose.yaml` and `storage/`, which Git ignores, but discards any edit you
> made to the repository's own files. Afterwards, `git pull` works again.

[image-lost-city-rs-versions]: https://github.com/mserajnik/lost-city-rs-deploy/pkgs/container/lost-city-rs/versions?filters%5Bversion_type%5D=tagged
[lost-city-rs-content]: https://github.com/LostCityRS/Content
[lost-city-rs-engine]: https://github.com/LostCityRS/Engine-TS
