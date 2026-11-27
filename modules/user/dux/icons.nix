{ pkgs, ... }:

let
  iconTheme = "Tela-circle-dark";

  environment = {
    QS_ICON_THEME = iconTheme;
  };
in
{
  home.packages = [
    pkgs.tela-circle-icon-theme
  ];

  programs.dank-material-shell.settings = {
    iconThemeDark = iconTheme;
    iconThemeLight = iconTheme;
    iconThemePerMode = false;
  };

  home.sessionVariables = environment;
  systemd.user.sessionVariables = environment;
}