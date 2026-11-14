{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.dux-greeter.nixosModules.default
  ];

  programs.dms-greeter = {
    enable = true;

    compositor = {
      name = "hyprland";

      customConfig = ''
        hl.config({
          input = {
            kb_layout = "fr",
            kb_variant = ""
          },

          misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
            background_color = "rgb(000000)"
          }
        })
      '';
    };

    configHome = config.hostSpec.homeDirectory;
  };
}
