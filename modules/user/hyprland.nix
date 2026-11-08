{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
  };
  
  home.packages = with pkgs; [
    kitty
    # starship
  ];
}