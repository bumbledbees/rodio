{
  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs?rev=675a6157205d7f15e42edceaa959460fa002d1d3";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs: inputs.utils.lib.eachDefaultSystem (
      system: let
        pkgs = inputs.nixpkgs.legacyPackages.${system}.extend inputs.rust-overlay.overlays.default;
        rust = pkgs.rust-bin.stable."1.97.0".minimal.override {
          extensions = [ "rust-src" "rust-analyzer" "rustfmt-preview" "clippy-preview" ];
        };
      in {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            rust
            cargo-outdated
          ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            pkg-config
          ];

          buildInputs = with pkgs; [
          ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            alsa-lib
          ];
        };
      }
    );
}
