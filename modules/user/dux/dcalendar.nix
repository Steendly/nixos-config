{ inputs, ... }:

{
  imports = [ inputs.dcalendar.homeModules.dank-calendar ];

  programs.dank-calendar = {
    enable = true;
    systemd.enable = true;
  };
}