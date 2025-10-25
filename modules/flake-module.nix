{
  self,
  lib,
  moduleLocation,
  ...
}:

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
        virtualisation = ./virtualisation.nix;
      };
  };
}
