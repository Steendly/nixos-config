{ ... }:

{
  imports = [
    ../hyprland
    ./greeter.nix
    ./boot-screen.nix
    ./cursor.nix
  ];

  # For DFiles (Dux-Files)
  services.udisks2.enable = true;
  services.gvfs.enable = true;
}