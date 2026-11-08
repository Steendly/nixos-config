{ config, ... }:

{
  imports = [
    # ./hardware-configuration.nix
    ../../modules/host-spec.nix
    ./configuration.nix
  ];

  hostSpec = {
    username = "azcos";
    stateVersion = "26.05";
  };

}