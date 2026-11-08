{ inputs, config, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit inputs;
    };

    users.${config.hostSpec.username} = {
      imports = [
        ../hosts/${config.hostSpec.hostname}/home.nix
      ];

      home.username = config.hostSpec.username;
      home.homeDirectory = config.hostSpec.homeDirectory;
      home.stateVersion = config.hostSpec.stateVersion;
    };
  };
}