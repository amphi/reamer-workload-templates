{
  description = "vhost-user-blk backend for LUKS encrypted block-devices";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dried-nix-flakes.url = "github:cyberus-technology/dried-nix-flakes";
    crane.url = "github:ipetkov/crane/master";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    (inputs.dried-nix-flakes.for inputs).exportOutputs (
      {
        self,
        crane,
        nixpkgs,
        rust-overlay,
        ...
      }:
      let
        pkgs = nixpkgs.legacyPackages;
        rust-bin = (rust-overlay.lib.mkRustBin { }) pkgs;
        packageName = (builtins.fromTOML (builtins.readFile ./Cargo.toml)).package.name;
      in
      {
        formatter = pkgs.nixfmt-tree;
        devShells.default = pkgs.mkShellNoCC {
          inputsFrom = builtins.attrValues self.packages;
          packages = with pkgs; [
            rustup
          ];
        };
        packages =
          let
            sourceFilter = path: type: craneLib.filterCargoSources path type;
            src = pkgs.lib.cleanSourceWith {
              src = self;
              filter = sourceFilter;
              name = "source";
            };

            rustToolchain = rust-bin.stable.latest.default;
            craneLib = (crane.mkLib pkgs).overrideToolchain rustToolchain;

            rustPackage =
              let
                commonArgs = {
                  inherit src;
                };

                cargoArtifacts = craneLib.buildDepsOnly (commonArgs);

              in
              craneLib.buildPackage (commonArgs // { inherit cargoArtifacts; });

            rustBinary = pkgs.runCommand "reamer-example" { } ''
              install -Dm755 ${rustPackage}/bin/${packageName} $out
            '';

          in
          {
            inherit rustPackage;
            default = rustBinary;
          };
      }
    );
}
