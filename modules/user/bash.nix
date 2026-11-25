{ config, lib, pkgs, ... }:

let
  colors = config.theme.colors;

  blesh = pkgs.blesh.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      sed -i '/\[ble: exit\]/s/.*/:/' "$out/share/blesh/ble.sh"
    '';
  });
in
{
  imports = [
    ./theme.nix
  ];

  programs.bash = {
    enable = true;

    initExtra = ''
      source "${blesh}/share/blesh/ble.sh" --rcfile "${config.xdg.configHome}/blesh/init.sh"
    '';
  };

  xdg.configFile."blesh/init.sh".text = ''
    bleopt prompt_ps1_transient=always:trim
    bleopt prompt_ruler=empty-line
    ble-face -s region_insert 'fg=${colors.surface},bg=${colors.onSurface}'
  '';

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = "always";
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      add_newline = false;

      format = lib.concatStrings [
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
          "[](fg:${colors.surface})"
          "[$output on 🌐 ](bold fg:${colors.onSurface} bg:${colors.surface})"
          "[](fg:${colors.onSurface} bg:${colors.surface})"
        ];
      };

      custom.local_directory_edge = {
        when = ''test -z "$SSH_CONNECTION$SSH_CLIENT$SSH_TTY"'';
        format = "[](fg:${colors.onSurface})";
      };

      character = {
        success_symbol = "[ ](bold fg:${colors.onSurface})";
        error_symbol = "[ ](bold fg:${colors.error})";
      };

      directory = {
        style = "bg:${colors.onSurface} fg:${colors.surface}";
        truncation_length = 2;
        truncation_symbol = ".../";
        format = "[󰉋 → $path]($style)[](bold fg:${colors.onSurface})";
      };
    };
  };
}