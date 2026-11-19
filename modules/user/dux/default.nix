{ inputs, lib, pkgs, config, ... }:

let
  dms = lib.getExe config.programs.dank-material-shell.package;
in
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    
    ../hyprland
    ../kitty.nix
    ../bash.nix
    
    ./cursor.nix
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
      # Greeter
      greeterRememberLastSession = true;

      # Dynamic theme
      currentThemeName = "dynamic";
      currentThemeCategory = "dynamic";

      # Lock Screen
      lockScreenWidgetInstances = [
        {
          id = "lock_clock";
          widgetType = "desktopClock";
          enabled = true;
          config = {
            style = "expressive";
            showDate = false;
            autoPosition = false;
          };
        }
        {
          id = "lock_auth";
          widgetType = "lockAuth";
          enabled = true;
          config = {
            style = "expressive";
            profileVisibility = "always";
            passwordVisibility = "always";
          };
        }
        {
          id = "lock_notifications";
          widgetType = "lockNotifications";
          enabled = true;
          config.mode = 2;
        }
        {
          id = "lock_status";
          widgetType = "lockStatus";
          enabled = true;
          config = {
            showMediaPlayer = true;
            showWeather = true;
            background = false;
          };
        }
        {
          id = "lock_power";
          widgetType = "lockPower";
          enabled = true;
          config.shape = "round";
        }
      ];
    };
  };

  # Set wallpaper
  systemd.user.services.dms.Service.ExecStartPost = [
    ''${dms} ipc call wallpaper set "${config.theme.wallpaper}"''
  ];

  home.packages = with pkgs; [

  ];

  programs.kitty.extraConfig = lib.mkIf config.programs.kitty.enable ''
    include dank-theme.conf
  '';
}