{ lib, pkgs, ... }:

{
  programs.bash.enable = true;

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = "always";
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings =
      let
        colors = {
          dark = "#474747";
          muted = "#B9B9B9";
          bright = "#F1F1F1";
          error = "#FFB4AB";
        };
      in
      {
        add_newline = false;
        
        format = lib.concatStrings [
          "$line_break"
          "\${custom.ssh_user}"
          "\${custom.local_directory_edge}"
          "$directory"
          "$line_break"
          "$character"
        ];

        custom.ssh_user = {
          when = ''test -n "$SSH_CONNECTION$SSH_CLIENT$SSH_TTY"'';
          command = "${pkgs.coreutils}/bin/id -un";

          format = lib.concatStrings [
            "[](fg:${colors.dark})"
            "[$output on 🌐 ](bold fg:${colors.bright} bg:${colors.dark})"
            "[](fg:${colors.muted} bg:${colors.dark})"
          ];
        };

        custom.local_directory_edge = {
          when = ''test -z "$SSH_CONNECTION$SSH_CLIENT$SSH_TTY"'';
          format = "[](fg:${colors.muted})";
        };

        character = {
          success_symbol = "[ ](bold fg:${colors.muted})";
          error_symbol = "[ ](bold fg:${colors.error})";
        };

        directory = {
          style = "bg:${colors.muted} fg:${colors.dark}";
          truncation_length = 2;
          truncation_symbol = ".../";
          format = "[󰉋 → $path]($style)[](bold fg:${colors.muted})";
        };
      };
  };
}