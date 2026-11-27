{ config, ... }:

{
  imports = [
    # ./hardware-configuration.nix
    ../../modules/host-spec.nix
    ../../modules/home-manager.nix

    ./configuration.nix
    
    ../../modules/system/dux
    ../../modules/system/nix.nix
  ];

  hostSpec = {
    username = "azcos";
    stateVersion = "26.05";
  };

}