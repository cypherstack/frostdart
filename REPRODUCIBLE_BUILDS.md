# Reproducible native builds

The Nix build produces the Linux `frostdart.so` from the exact Serai revision
recorded by the `src/serai` submodule. `flake.lock` pins that source, nixpkgs,
the Rust overlay, and the Rust 1.71.0 toolchain used by the existing build
scripts. Cargo dependencies are captured by a fixed-output vendor hash.

```sh
nix build .#frostdart
./nix/verify-reproducible.sh
```

Debug paths are removed, sandbox paths are remapped, and
`SOURCE_DATE_EPOCH` is fixed. The verifier requests a second Nix build and
fails if its output differs.

This derivation currently covers Linux. Android, Windows, and Apple SDK inputs
need separately pinned cross-compilation derivations.
