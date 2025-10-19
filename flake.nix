{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      treefmt-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        treefmt-nix.flakeModule
        ./modules/flake-module.nix
        ./scripts.nix
      ];

      systems = [ "x86_64-linux" ];

      perSystem = {
        treefmt = {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
        };
      };
    };
}
