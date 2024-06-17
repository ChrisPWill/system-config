{
  lib,
  config,
  home-manager,
  ...
}:
with lib; {
  imports = [
    home-manager
  ];

  options = {
    mainUsername = mkOption {
      type = types.str;
      default = "cwilliams";
    };

    mainHomeDir = mkOption {
      type = types.str;
      default = "/home/${config.mainUsername}";
    };

    mainUserStateVersion = mkOption {
      type = types.str;
      default = "24.05";
    };
  };

  config = {
    users.users.${config.mainUsername} = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
    home-manager.users.${config.mainUsername} = {
      home = {
        # Home Manager needs a bit of information about the user and
        # paths it should manage.
        username = config.mainUsername;
        homeDirectory = config.mainHomeDir;

        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        stateVersion = "24.05";
      };

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };
}
