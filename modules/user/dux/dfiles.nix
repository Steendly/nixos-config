{ inputs, ... }:

{
  imports = [ inputs.dfiles.homeModules.dux-files ];

  programs.dux-files = {
    enable = true;

    # Keep a resident instance so windows open fast and the portal answers at once
    systemd = {
      enable = true;
      target = "graphical-session.target";
      restartIfChanged = true;
    };

    # Serve other apps' open and save dialogs
    portal = {
      enable = true;      # register the dfiles backend with xdg-desktop-portal
      preferred = true;   # prefer it for org.freedesktop.impl.portal.FileChooser
      desktop = "hyprland";   # which xdg.portal.config entry gets the preference, "common" by default
    };
  };
}