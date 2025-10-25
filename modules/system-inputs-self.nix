{ flakeConfig }:
{
  config,
  lib,
  pkgs,
  inputs,
  self,
  ...
}:

# This module provides a system specific inputs' and self' module argument.
# This permits users to use packages from inputs or self in a system agnostic manner,
# e.g., writing self'.packages.default instead of self.packages.${system}.default.
# Users must add inputs and/or self to specialArgs first before enabling this module.
# MODULE AUTHORS, please do not depend on these arguments in any contributed modules.
let
  inherit (pkgs) system;
  inherit (flakeConfig) perInput;
  cfg = config.monarch.modules;
in
{
  options.monarch.modules = {
    self'.enable = lib.mkEnableOption "system specific self module argument";
    inputs'.enable = lib.mkEnableOption "system specific inputs module argument";
  };

  config = {
    _module = lib.mkMerge [
      ({ args = lib.mkIf cfg.self'.enable { self' = perInput system self; }; })
      ({
        args = lib.mkIf cfg.inputs'.enable {
          inputs' = lib.mapAttrs (
            inputName: input: if input._type or null == "flake" then perInput system input else null
          ) inputs;
        };
      })
    ];
  };
}
