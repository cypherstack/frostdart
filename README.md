# frostdart

Dart bindings for the Serai FROST multisig implementation. Rust sources live in
`src/serai`; the package ships the compiled library through native assets.

Requires Dart 3.13+ (or a Flutter SDK containing it). Nothing else is needed
to use the package: the build hook downloads the library built for this
version and checks its hash.

```sh
dart pub get --no-example
dart test
```

Consuming Flutter apps use normal `flutter run` / `flutter build` commands.
The example requires iOS 15+ or macOS 13+ for Apple builds.

Regenerate bindings with `dart run ffigen --config ffigen.yaml` (requires libclang).

## Native library

The hook obtains the Rust library in one of three modes, chosen with the
`build` user define in the consuming app's `pubspec.yaml`, or for this
checkout with a `.dnix-build` file holding the mode:

```yaml
hooks:
  user_defines:
    frostdart:
      build: prebuilt   # the default; or source, or dev
```

- `prebuilt` downloads the library of the release `dnix.lock` names and
  verifies it against the hash recorded there. A mismatch is an error, never
  a fallback. Downloads are cached by hash.
- `source` builds the library with Nix, the same build CI uses, and verifies
  it against the same hash. Needs Nix on Linux or an Apple Silicon Mac; the
  Apple targets need Xcode 27.0.
- `dev` builds with Nix but skips the Xcode pin and the hash check, for
  working on the Rust code. The hook notices a `.dnix-build` file from its
  next run on, so touch `dnix.json` after creating it.

Only dynamic libraries are provided, built for macOS 12, iOS 13 (the arm64
simulator 14), Android API 24, and glibc 2.28 at minimum. iOS stays at 13
because Flutter 3.47 asks build hooks for iOS 13 and writes 13.0 into each
native asset's framework as its minimum. The floors, the Rust and Xcode
versions, and the location of the Rust workspace live in `dnix.json`.

### Releases

`dnix.lock` records the hash of every library the Rust source builds to and
names the GitHub release, `native-<release>`, that holds those bytes. After
changing the Rust code, run `dart tool/update_lock.dart` on a Mac with Nix
and Xcode 27.0 and commit the lock with the change; without a Mac, push and
copy the lock CI prints once every host is green. CI
(`.github/workflows/native.yml`) builds on four hosts, fails if any host or
the lock disagrees, and publishes the release when the lock reaches the
default branch. Nothing is ever committed by CI, and old releases stay.

Anyone can rebuild one platform with Nix and compare:
`dart tool/verify_release.dart linux` (or android, windows, macos, ios, or a
target triple), on Windows inside WSL2 for the non-Apple platforms. The Apple
platforms use the Xcode 27.0 bundle under `/Applications`, whatever
`xcode-select` points at.

### How the build stays reproducible

The build comes from the shared [dnix](https://github.com/cypherstack/dnix)
package: `flake.nix` hands it `dnix.json`, and dnix builds every non-Apple
target in a Nix sandbox from toolchains pinned by hash, with the same bytes
on Linux, macOS, and WSL2, and the Apple targets with the pinned Xcode. See
dnix's documentation for how the output is kept independent of the host.

```sh
nix build .#x86_64-unknown-linux-gnu    # one target, output in result/lib
nix build .#all                         # every target this host can build
cat result/SHA256SUMS
nix develop .#apple --command dnix-apple-build out   # Apple targets, pinned Xcode
```

Bumping Rust means changing `toolchains.rust` in `dnix.json`, plus
`src/serai/hrf/rust-toolchain.toml` and the toolchain step in
`.github/workflows/release.yml`, which serve `cargo test`. Bumping dnix means
the same commit in `pubspec.yaml`, `flake.lock`, and
`.github/workflows/native.yml`. Either is followed by `update_lock`.

### Tests

`.github/workflows/release.yml` runs the Dart tests on every OS: against the
prebuilt library once the lock's release is published, from source before
that (Windows waits for the release), and the Rust tests on Linux.
