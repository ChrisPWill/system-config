{loginUser ? "cwilliams"}: {pkgs, ...}: {
  imports = [
    (import ./hyprland {inherit loginUser;})
  ];

  services.gvfs.enable = true;

  # Disabled for pipewire instead
  # hardware.pulseaudio = {
  #   enable = true;
  #   support32Bit = true;
  # };

  # Server and user space API to deal with multimedia pipelines
  # i.e. screen sharing
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    pulseaudio
    pipewire
    gperftools
  ];

  hardware.graphics = {
    enable32Bit = true;

    extraPackages = with pkgs; [
      # VAAPI
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
