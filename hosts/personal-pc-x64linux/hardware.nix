{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./vfio.nix
  ];
  system.stateVersion = "23.11";
  networking.hostName = "personal-pc-x64linux";
  networking.hostId = "579220d5";

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod"];
      kernelModules = [
        "amdgpu"
      ];
      luks.devices = {
        "cryptRoot".device = "/dev/disk/by-uuid/fce35182-af3a-4389-af54-527041ba8595";
      };
    };
    kernelModules = ["kvm-amd amdgpu"];
    extraModulePackages = [];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems."/" = {
    device = "zroot/ROOT/default";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zroot/data/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zroot/nix";
    fsType = "zfs";
  };

  fileSystems."/var" = {
    device = "zroot/var";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9830-B4C3";
    fsType = "vfat";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/31889efe-0b68-41c6-ad49-e324d816891a";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s3.useDHCP = lib.mkDefault true;

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = true;

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  # hardware.nvidia.modesetting.enable = true;
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;

  # Logitech
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # Enable mechanical keyboard config e.g. Via
  hardware.keyboard.qmk.enable = true;
  environment.systemPackages = with pkgs; [
    via
  ];
  services.udev.packages = [pkgs.via];
}
