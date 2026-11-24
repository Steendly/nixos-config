{ ... }:

{
  wayland.windowManager.hyprland.settings.config = {
    general = {
      gaps_in = 5;
      gaps_out = 5;
      border_size = 2;
    };

    decoration  = {
      rounding = 12;
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      shadow = {
        enabled = true;
        range = 30;
        render_power = 4;
        offset = "0 5";
        color = "rgba(00000070)";
      };
    };
  };
}