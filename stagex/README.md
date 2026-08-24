# StageX build

This is a StageX `user` package definition for the Linux HRF library. It
targets StageX commit `9bdf430d09ce2ba53932df0182faef00d4feecd1`;
`stagex.lock` records the expected amd64 dependency-image digests.

Copy this directory to `packages/user/stack-wallet-frostdart` in a checkout
of that StageX revision, add it to the Git index, then run:

```sh
make fetch PKG=stack-wallet-frostdart
make user-stack-wallet-frostdart NOCACHE=1
python3 src/package-digests.py user-stack-wallet-frostdart
```

The exact Serai source archive is SHA-256 locked. Cargo performs its fetch
step from the checked-in lock file before the build, and compilation then runs
offline. Reproduce on an independent builder and compare the image digest.
