{ flakeConfig, ... }:
{
  config,
  lib,
  pkgs,
  self,
  ...
}:

# This module provides a system specific self' module argument.
# This permits users to use packages from self in a system agnostic manner,
# e.g., self'.packages.default instead of self.packages.${system}.default.
# Users must add self to specialArgs first before importing this module.
# MODULE AUTHORS, please do not depend on self' in any contributed modules.
let
  inherit (pkgs) system;
  inherit (flakeConfig) perInput;
  cfg = config.monarch.modules.self';
in
{
  options.monarch.modules.self' = {
    enable = lib.mkEnableOption "system specific self module argument";
  };

  config = lib.mkIf cfg.enable {
    _module.args.self' = perInput system self;
  };
}
