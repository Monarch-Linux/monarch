{
  self,
  lib,
  moduleLocation,
  ...
}:

{
  flake = {
    nixosModules = {
      default =
        let
          monarchModules = lib.filterAttrs (n: _: n != "default") self.nixosModules;
        in
        {
          _file = "${toString moduleLocation}#nixosModules.default";
          imports = lib.mapAttrsToList (_: v: v) monarchModules;
        };
      virtualisation = ./virtualisation.nix;
    };
  };
}
