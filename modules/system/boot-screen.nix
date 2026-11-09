{ config, pkgs, ... }:

let
  themeName = "material-loading";
  python = pkgs.python3.withPackages (ps: [ ps.pillow ]);
  theme = pkgs.runCommand "plymouth-${themeName}" { nativeBuildInputs = [ python ]; } ''
    spinnerDir=${config.boot.plymouth.package}/share/plymouth/themes/spinner
    themeDir="$out/share/plymouth/themes/${themeName}"
    mkdir -p "$themeDir"

    cp "$spinnerDir"/*.png "$themeDir/"
    rm -f "$themeDir"/throbber-*.png
    python3 ${../../assets/boot-screen/loading-boot.py} \
      --geometry ${../../assets/boot-screen/material-shapes.json} "$themeDir"

    sed -e 's/^Name=.*/Name=Material Loading/' \
        -e "s|^ImageDir=.*|ImageDir=$themeDir|" \
        -e 's/^VerticalAlignment=.*/VerticalAlignment=.5/' \
        "$spinnerDir/spinner.plymouth" > "$themeDir/${themeName}.plymouth"
  '';
in
{
  boot.plymouth = {
    enable = true;
    theme = themeName;
    themePackages = [ theme ];
  };
}
