{ inputs, lib, pkgs, config, ... }:

let
  dms = lib.getExe config.programs.dank-material-shell.package;
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    ../hyprland
    ../kitty.nix
    ./binds.nix
  ];

  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dank-material-shell changes
    };

    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets
    enableVPN = true;                  # VPN management widget
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)

    # Personal settings
    settings = {
      currentThemeName = "dynamic";
      currentThemeCategory = "dynamic";
      greeterRememberLastSession = true;
    };
  };

  # Set wallpaper & dynamic theme
  systemd.user.services.dms.Service.ExecStartPost = [
    # "${dms} ipc call settings set currentThemeCategory dynamic"
    # "${dms} ipc call settings set currentThemeName dynamic"
    ''${dms} ipc call wallpaper set "${config.theme.wallpaper}"''
  ];

  home.packages = with pkgs; [

  ];

  programs.kitty.extraConfig = lib.mkIf config.programs.kitty.enable ''
    include dank-theme.conf
  '';
}