{...}: {
  programs = {
    nushell = {
      enable = true;
      configFile.source = ./nushell/config.nu;
    };

    carapace.enable = true;
    carapace.enableNushellIntegration = true;

    # Disabled for now because it causes weird issues when nu and zsh are enabled
    # starship = {
    #   enable = true;
    #   settings = {
    #     add_newline = true;
    #     character = {
    #       success_symbol = "[➜](bold green)";
    #       error_symbol = "[➜](bold red)";
    #     };
    #   };
    # };
  };
}
