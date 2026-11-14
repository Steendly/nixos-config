{ config, ... }:

{
  imports = [
    # ./hardware-configuration.nix
    ../../modules/host-spec.nix
    ../../modules/home-manager.nix

    ./configuration.nix
    
    ../../modules/system/hyprland
    ../../modules/system/dux
  ];

  hostSpec = {
    username = "azcos";
    stateVersion = "26.05";
  };

}