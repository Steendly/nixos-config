{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, home-manager, ... }@inputs:
    let
      mkHost = hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs hostname;
          };

          modules = [
            home-manager.nixosModules.home-manager
            ./hosts/${hostname}
          ];
        };
    in {
      nixosConfigurations = {
        tester = mkHost "tester";
      };
    };
}