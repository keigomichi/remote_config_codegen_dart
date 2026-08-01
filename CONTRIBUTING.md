# Contributing

Thanks for contributing to `remote_config_codegen`.

## Requirements

Use Dart 3.11 or later. CI runs the test suite against both the minimum
supported SDK (3.11.0) with the lowest allowed dependencies and the latest
stable SDK with the latest allowed dependencies. Formatting runs once on the
latest stable SDK so that a single formatter defines the expected result.

This repository is a published package, so `pubspec.lock` is not committed.
CI validates the dependency range declared in `pubspec.yaml` instead of
reproducing one locked dependency graph.

## Set up and verify

From the repository root, resolve the latest allowed dependencies and run the
normal checks:

```sh
dart pub upgrade --no-example
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos lib bin test
dart test
```

Keep user-facing documentation in [README.md](README.md) up to date.

## Pull request titles

Pull request titles follow the Conventional Commits format because squash
merges become the commit history used by Release Please:

```text
<type>[optional scope][!]: <description>
```

Use one of these types:

- `feat` for a new user-facing feature.
- `fix` for a user-facing bug fix.
- `perf` for a user-facing performance improvement.
- `revert` for reverting a prior change.
- `build`, `chore`, `ci`, `docs`, `refactor`, `style`, or `test` for changes
  that do not need their own release note.

Add `!` before the colon, or a `BREAKING CHANGE:` footer, for a breaking
change. Scopes are optional.

## Release validation

CI verifies every pull request with both the lowest and latest allowed
dependencies. It also runs a publish dry run. To perform the same release
validation locally:

```sh
dart pub downgrade --no-example
dart analyze --fatal-infos lib bin test
dart test
dart pub upgrade --no-example
dart pub publish --dry-run
```

Do not update the top-level `version` in `pubspec.yaml` or released sections in
`CHANGELOG.md` as part of a normal pull request. Release Please owns those
changes and keeps the release manifest in sync.

After releasable changes reach `main`, Release Please creates or updates a
release pull request. Merging that pull request creates the version tag and
GitHub Release. The tag then publishes the same version to pub.dev through
GitHub Actions using OIDC. Do not run `dart pub publish` manually for later
versions.
