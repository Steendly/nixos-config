{ inputs, config, ... }:

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
          }
        })
      '';
    };

    configHome = config.hostSpec.homeDirectory;
  };
}