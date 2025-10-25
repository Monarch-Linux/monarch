{ flakeConfig, ... }:
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

# This module provides a system specific inputs' module argument.
# This permits users to use packages from inputs in a system agnostic manner,
# e.g., inputs'.nh.packages.nh instead of inputs.nh.packages.${system}.nh.
# Users must add inputs to specialArgs first before importing this module.
# MODULE AUTHORS, please do not depend on inputs' in any contributed modules.
let
  inherit (pkgs) system;
  inherit (flakeConfig) perInput;
  cfg = config.monarch.modules.inputs';
in
{
  options.monarch.modules.inputs' = {
    enable = lib.mkEnableOption "system specific inputs module argument";
  };

  config = lib.mkIf cfg.enable {
    _module.args.inputs' = lib.mapAttrs (
      inputName: input: if input._type or null == "flake" then perInput system input else null
    ) inputs;
  };
}
