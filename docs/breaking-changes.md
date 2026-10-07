# Breaking changes

Some updates require you to adjust your configuration. These breaking changes
are listed below, newest first.

The Docker image checks `LOST_CITY_RS_DEPLOY_VERSION` on startup. Each breaking
change raises the number it expects by 1, and thus prevents installations that
lack the necessary adjustments for the breaking change from starting.

To update across a version, first refresh your clone of this repository, as the
[updating your clone section](usage.md#updating-your-clone) describes, so you
have the new example Compose file to compare with.

Then apply every entry up to that version, and set
`LOST_CITY_RS_DEPLOY_VERSION` to that number in the `app` service in your
`compose.yaml`.

## Version 1 (2026-10-04)

The relaunch replaced the history of this repository, so `git pull` fails in a
clone from before 2026-10-04. To update such a clone once, run `git fetch` and
then `git reset --hard origin/master` in it. That keeps your `compose.yaml` and
`storage/`, which Git ignores, but discards any edit you made to the
repository's own files. Otherwise, make a new clone of the repository and move
these over without replacing the repository's own files. Either way, `git pull`
works again afterwards.

Version 1 makes several changes to the Compose file, which would be cumbersome
to make by hand. Instead, it is recommended to start from a fresh copy of the
example Compose file, and then re-apply your customizations there.

Version 1 brings these changes:

- The container now starts as root and switches to the UID and GID from
  `LOST_CITY_RS_UID` and `LOST_CITY_RS_GID`. Setting `user` instead stops the
  container with an error.
- The image now checks `LOST_CITY_RS_DEPLOY_VERSION` on startup and stops when
  it is missing or different.
- The example Compose file has a `check-deploy-version` service, which the
  [updating section](usage.md#updating) describes.

> [!NOTE]
> Changes from before version 1 are superseded, and you do not need to
> incorporate them into your configuration if you start from a fresh copy of
> the example Compose file. If you decide to keep and adjust your old file
> instead, compare it with the new example Compose file to find any other
> changes from before version 1 that you still have to make.
