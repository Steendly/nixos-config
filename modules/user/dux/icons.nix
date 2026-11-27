{ pkgs, ... }:

{
  home.packages = [
    pkgs.papirus-icon-theme
  ];

  programs.dank-material-shell.settings = {
    iconThemeDark = "Papirus-Dark";
    iconThemeLight = "Papirus";
    iconThemePerMode = true;
  };
}