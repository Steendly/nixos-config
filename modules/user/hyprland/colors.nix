{ config, ... }:

let
  colors = config.theme.colors;
in
{
  wayland.windowManager.hyprland.settings.config = {
    general = {
      col = {
        active_border = colors.primary;
        inactive_border = colors.background;
      };
    };

    group = {
      col = {
        border_active = colors.primary;
			  border_inactive = colors.background;
			  border_locked_active = colors.onBackground;
			  border_locked_inactive = colors.background;
      };

      groupbar = {
        col = {
  				active = colors.primary;
				  inactive = colors.background;
				  locked_active = colors.onBackground;
				  locked_inactive = colors.background;
        };
      };
    };
  };
}