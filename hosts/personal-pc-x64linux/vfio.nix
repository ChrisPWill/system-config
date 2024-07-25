let
  # RTX 3080
  gpuIDs = [
    "2d:00.0" # Graphics
    "2d:00.1" # Audio
  ];
in
  {
    lib,
    config,
    ...
  }: {
    options.vfio.enable = with lib;
      mkEnableOption "Configure the machine for VFIO";

    config = let
      cfg = config.vfio;
    in {
      specialisation."VFIO".configuration = {
        system.nixos.tags = ["with-vfio"];
        vfio.enable = true;
      };
      boot = {
        initrd.kernelModules = [
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"

          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
        ];

        kernelParams =
          [
            # enable IOMMU
            "amd_iommu=on"
          ]
          ++ lib.optionals cfg.enable [
            ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs)
          ];
      };
      # SPICE redirection lets you essentially hotplug USB keyboards, mice, storage, etc. from the host into the guest
      virtualisation.spiceUSBRedirection.enable = true;
    };
  }
