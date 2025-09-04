# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Enable numlock as early as possible
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ ];
      preLVMCommands = ''
        ${pkgs.kbd}/bin/setleds +num
      '';
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
    tmp.cleanOnBoot = true;
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    config.allowUnfree = true;
  };

  networking = {
    useDHCP = lib.mkDefault true;
    hostName = "miy-nixos";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty
  };

  security.rtkit.enable = true;
  services = {
    xserver = {
      enable = true;
      displayManager.lightdm.enable = false;
      # Configure keymap in X11
      xkb = {
        layout = "us";
        options = "eurosign:e";
      };
    };

    getty.autologinUser = "miy";

    # Enable sound.
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber = {
        enable = true;
      };
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  users.users = {
    root = {
      initialHashedPassword = "$6$4Jxjcmy7vpS6CslQ$APW/LBTfbJN9oNKRQ.bReOEZoDlSMke5Hv/BKoM2Qrzsxq4tRxFK21CAHtp9CGVaKYAdh/eVlzGuM0CE0hzrW/";
    };
    miy = {
      isNormalUser = true;
      description = "miy";
      initialHashedPassword = "$6$4Jxjcmy7vpS6CslQ$APW/LBTfbJN9oNKRQ.bReOEZoDlSMke5Hv/BKoM2Qrzsxq4tRxFK21CAHtp9CGVaKYAdh/eVlzGuM0CE0hzrW/";
      extraGroups = [
        "wheel"
      ];
    };
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    xwayland-satellite
    steam
  ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  # auto maintainance: collect garbage, optimize, upgrade
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    optimise = {
      automatic = true;
      dates = [ "03:00" ];
    };
  };

  # system theme, can be overwritten in the home modules
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa-dragon.yaml";

  programs.niri.enable = true;
  programs.ssh.startAgent = true;

  system.stateVersion = "25.11"; # Did you read the comment?
}
