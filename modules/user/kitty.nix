{ pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    shellIntegration.enableBashIntegration = true;

    # Font
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
      size = 12;
    };

    settings = {
      # Window configuration
      window_padding_width = "21.75";
      hide_window_decorations = true;
      remember_window_size = false;

      # Cursor configuration
      cursor_shape = "beam";
      cursor_blink_interval = 1;

      # Scrollback
      scrollback_lines = 3000;

      # Terminal features
      copy_on_select = true;
      strip_trailing_spaces = "smart";

      # Tab configuration
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      tab_bar_align = "left";
      tab_title_template = "{index}";

      # No close confirmation
      confirm_os_window_close = 0;
    };

    # Key bindings for common actions
    keybindings = {
      "ctrl+shift+n" = "new_window";
      "ctrl+t" = "new_tab";
      "ctrl+plus" = "change_font_size all +1.0";
      "ctrl+minus" = "change_font_size all -1.0";
      "ctrl+0" = "change_font_size all 0";
    };
  };
}