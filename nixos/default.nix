{loginUser ? "cwilliams"}: {pkgs, ...}: {
  imports = [
    (import ./hyprland {inherit loginUser;})
    ./personalMachine.nix
  ];

  services.gvfs.enable = true;

  # Enable audio
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudio
    pipewire
    gperftools
  ];

  hardware.opengl = {
    driSupport32Bit = true;
    # Vulkan
    driSupport = true;

    extraPackages = with pkgs; [
      # VAAPI
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
