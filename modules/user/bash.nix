{ config, lib, pkgs, ... }:

{
  imports = [
    ./theme.nix
  ];

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
        inherit (config.theme.colors) surface onSurface error;
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
            "[](fg:${surface})"
            "[$output on 🌐 ](bold fg:${onSurface} bg:${surface})"
            "[](fg:${onSurface} bg:${surface})"
          ];
        };

        custom.local_directory_edge = {
          when = ''test -z "$SSH_CONNECTION$SSH_CLIENT$SSH_TTY"'';
          format = "[](fg:${onSurface})";
        };

        character = {
          success_symbol = "[ ](bold fg:${onSurface})";
          error_symbol = "[ ](bold fg:${error})";
        };

        directory = {
          style = "bg:${onSurface} fg:${surface}";
          truncation_length = 2;
          truncation_symbol = ".../";
          format = "[󰉋 → $path]($style)[](bold fg:${onSurface})";
        };
      };
  };
}