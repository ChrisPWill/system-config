{
  description = "Chris Williams Nix Flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-24.05";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = import ./nixosConfigurations.nix inputs;
    darwinConfigurations = import ./darwinConfigurations.nix inputs;
  };
}
