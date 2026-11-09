{ config, ... }:

{
  imports = [
    # ./hardware-configuration.nix
    ../../modules/host-spec.nix
    ../../modules/home-manager.nix

    ./configuration.nix
    
    ../../modules/system/hyprland.nix
    ../../modules/system/dux-greeter.nix
    ../../modules/system/boot-screen.nix
  ];

  hostSpec = {
    username = "azcos";
    stateVersion = "26.05";
  };

}