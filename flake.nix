{
  description = "Chris Williams Nix Flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };

    nixos.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-lib.url = "github:NixOS/nixpkgs/nixos-24.05?dir=lib";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixos-lib";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixos-lib";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixos-lib";
    };
  };

  outputs = inputs: {
    nixosConfigurations = import ./nixosConfigurations.nix inputs;
    darwinConfigurations = import ./darwinConfigurations.nix inputs;
  };
}
