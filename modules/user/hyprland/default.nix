{ config, pkgs, ... }:

{
  imports = [
    ./input.nix
    ./decoration.nix
    ./colors.nix
    ./layout.nix
    ./misc.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    configType = "lua";

    settings.config = {

    };
  };
}