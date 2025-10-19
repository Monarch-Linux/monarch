{
  lib,
  config,
  options,
  ...
}:

let
  cfg = config.monarch.virtualisation;
in
{
  options.monarch.virtualisation = {
    enable = lib.mkEnableOption "virtual machine management";
    group.members = lib.mkOption {
      inherit ((options.users.groups.type.getSubOptions [ ]).members) type default description;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = cfg.group.members;
  };
}
