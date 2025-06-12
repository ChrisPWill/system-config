{
  description = "Chris Williams Nix Flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Aylur's GTK Shell https://aylur.github.io/ags-docs/
    # Wayland Widgets tool
    ags.url = "github:Aylur/ags";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs: {
    nixosConfigurations = import ./nixosConfigurations.nix inputs;
    darwinConfigurations = import ./darwinConfigurations.nix inputs;
    homeConfigurations = import ./homeConfigurations.nix inputs;
  };
}
