{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
  };
}