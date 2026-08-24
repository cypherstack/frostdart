{
  description = "Reproducible native builds for frostdart";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    serai = {
      url = "git+https://github.com/kayabaNerve/serai?rev=90ee77d805224d8c6641e4123adc2cc74b701c9f";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, rust-overlay, serai }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (import rust-overlay) ];
          };
          rustToolchain = pkgs.rust-bin.stable."1.71.0".minimal;
          rustPlatform = pkgs.makeRustPlatform {
            cargo = rustToolchain;
            rustc = rustToolchain;
          };
        in {
          frostdart = rustPlatform.buildRustPackage {
            pname = "frostdart";
            version = "0.2.0";
            src = serai;
            cargoRoot = ".";
            buildAndTestSubdir = "hrf";
            cargoHash = "sha256-ErGdeajx2EOLPObN5HhT4csAqROvakaSE+R1k2jk+p0=";

            cargoBuildFlags = [ "--lib" ];
            doCheck = false;

            env = {
              SOURCE_DATE_EPOCH = "1";
              RUSTFLAGS = "-C debuginfo=0 --remap-path-prefix=/build/source=.";
            };

            installPhase = ''
              runHook preInstall
              library="$(find target -name libhrf_api.so -print -quit)"
              test -n "$library"
              install -Dm755 "$library" "$out/lib/frostdart.so"
              runHook postInstall
            '';
          };

          default = self.packages.${system}.frostdart;
        });

      checks = forAllSystems (system: {
        inherit (self.packages.${system}) frostdart;
      });
    };
}
