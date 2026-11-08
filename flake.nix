{
  description = "NixOS configuration";

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