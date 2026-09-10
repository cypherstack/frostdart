# frostdart

Dart bindings for the Serai FROST multisig implementation. Rust sources live in
`src/serai`; native assets build and bundle them automatically.

Requires Dart 3.13+ (or a Flutter SDK containing it), Rust installed with rustup,
and the platform's C build tools: Xcode for Apple, the Android NDK, a Linux C
compiler, or Visual Studio's C++ build tools on Windows. Put `rustup` on PATH.
The hook locates the pinned Rust 1.90.0 tools and installs the target as needed.

```sh
dart pub get --no-example
dart test
```

Consuming Flutter apps use normal `flutter run` / `flutter build` commands.
The example requires iOS 15+ or macOS 13+ for Apple builds.

Regenerate bindings with `dart run ffigen --config ffigen.yaml` (requires libclang).
