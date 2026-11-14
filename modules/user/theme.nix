{ config, lib, pkgs, ... }:

let
  generatedColors = pkgs.runCommand "generate-theme-colors" {
    nativeBuildInputs = [ pkgs.matugen ];
  } ''
    cp "${../../assets/theme/matugen.toml}" ./matugen.toml
    cp "${../../assets/theme/template.json}" ./template.json

    matugen image "${config.theme.wallpaper}" \
      --config ./matugen.toml \
      --source-color-index 0

    mv ./colors.json "$out"
  '';
in
{
  options.theme = {
    wallpaper = lib.mkOption {
      type = lib.types.path;
      default = ../../assets/wallpapers/default_wallpaper.png;
    };

    colors = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = builtins.fromJSON (
        builtins.readFile "${generatedColors}"
      );
    };
  };
}