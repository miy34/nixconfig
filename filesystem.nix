{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/5E15-0762";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
      neededForBoot = true;
    };
    "/" = {
      device = "none";
      fsType = "tmpfs";
      neededForBoot = true;
      options = [
        "defaults"
        "size=4G"
        "mode=755"
      ];
    };
    "/persist" = {
      device = "/dev/disk/by-uuid/04cc0c9a-bb40-488b-a1ec-d819623c1988";
      fsType = "ext4";
      neededForBoot = true;
      options = [ "defaults" ];
    };
    "/system" = {
      device = "/dev/disk/by-uuid/07234625-b214-43d5-8b98-11f8c9ddb8d9";
      fsType = "ext4";
      neededForBoot = true;
    };
    "/mnt/data" = {
      device = "/dev/sda";
      fsType = "ext4";
    };
    #bindings
    "/nix" = {
      device = "/persist/nix";
      fsType = "none";
      options = [ "bind" ];
      neededForBoot = true;
    };
    "/var/log" = {
      device = "/system/var/log";
      fsType = "none";
      options = [ "bind" ];
    };

    "/var/tmp" = {
      device = "/system/var/tmp";
      fsType = "none";
      options = [ "bind" ];
    };
    "/tmp" = {
      device = "/system/tmp";
      fsType = "none";
      options = [ "bind" ];
    };
    "/etc/nixos" = {
      device = "/system/etc/nixos";
      fsType = "none";
      options = [ "bind" ];
    };
    "/etc/machine-id" = {
      device = "/system/etc/machine-id";
      fsType = "none";
      options = [ "bind" ];
    };
    "/etc/adjtime" = {
      device = "/system/etc/adjtime";
      fsType = "none";
      options = [ "bind" ];
    };
    "/var/lib/nixos" = {
      device = "/system/var/lib/nixos";
      fsType = "none";
      options = [ "bind" ];
    };
    "/var/lib/systemd" = {
      device = "/var/lib/systemd";
      fsType = "none";
      options = [ "bind" ];
    };
    "/var/lib/bluetooth" = {
      device = "/system/var/lib/bluetooth";
      fsType = "none";
      options = [ "bind" ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/1d2a6b08-f32e-4ebb-a07d-5fdf1fe1211c"; }
  ];

}
