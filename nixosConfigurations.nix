inputs @ {
  nixpkgs,
  home-manager,
  ...
}: let
  system = "x86_64-linux";
  theme = import ./utils/theme.nix;
  mkNixosConf = {
    hostname,
    stateVersion,
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit nixpkgs;
        inherit theme;
      };
      modules = [
        ./options.nix
        ./hosts/${hostname}
        ./hosts/personalLinuxMachine.nix
        {
          nixpkgs.config.allowUnfree = true;
          nixpkgs.config.permittedInsecurePackages = [
            "electron-27.3.11" # needed for logseq
          ];
        }
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {inherit inputs nixpkgs theme system;};
          };
        }
        (import ./users/me {inherit stateVersion;})
        (import ./nixos {})
      ];
    };
in {
  personal-pc-x64linux = mkNixosConf {
    hostname = "personal-pc-x64linux";
    stateVersion = "23.11";
  };
  personal-vm = mkNixosConf {
    hostname = "personal-vm";
    stateVersion = "24.05";
  };
}
