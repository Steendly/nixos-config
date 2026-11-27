{
  description = "NixOS configuration";

  nixConfig = {
    extra-substituters = [
      "https://nix-cache.duxlabs.dev"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "dux-1:lrBykuzHKu9F6WsCbK83C9/uOrfqUY1kflRZtrUcMF0="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:duxlabs-dev/dux-shell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dsearch = {
      url = "github:duxlabs-dev/dux-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dcalendar = {
      url = "github:duxlabs-dev/dux-calendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    dux-greeter = {
      url = "github:duxlabs-dev/dux-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ... }@inputs:
    let
      mkHost = hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs hostname;
          };

          modules = [
            ./hosts/${hostname}
          ];
        };
    in {
      nixosConfigurations = {
        tester = mkHost "tester";
      };
    };
}