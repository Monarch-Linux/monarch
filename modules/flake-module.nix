{
  self,
  config,
  lib,
  moduleLocation,
  ...
}:

let
  inherit (lib.modules) importApply;
in
{
  flake = {
    nixosModules =
      let
        monarchModules = lib.filterAttrs (n: _: n != "default") self.nixosModules;
        default = {
          _file = "${toString moduleLocation}#nixosModules.default";
          imports = lib.mapAttrsToList (_: v: v) monarchModules;
        };
      in
      {
        inherit default;
        system-inputs = importApply ./system-inputs.nix { flakeConfig = config; };
        system-self = importApply ./system-self.nix { flakeConfig = config; };
        virtualisation = ./virtualisation.nix;
      };
  };
}
