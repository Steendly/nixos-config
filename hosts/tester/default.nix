{ config, ... }:

{
  imports = [
    # ./hardware-configuration.nix
    ../../modules/host-spec.nix
    ./configuration.nix
  ];

  hostSpec = {
    hostname = "ZXY";
    username = "azcos";
    stateVersion = "26.05";
  };

}