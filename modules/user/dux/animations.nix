{ ... }:

let
  curve = name: points: {
    _args = [
      name
      {
        type = "bezier";
        inherit points;
      }
    ];
  };

  animation = leaf: speed: bezier: {
    inherit leaf speed bezier;
    enabled = true;
  };
in
{
  wayland.windowManager.hyprland = {
    configType = "lua";

    settings = {
      config.animations.enabled = true;

      curve = [
        (curve "dms_fade" [
          [ 0.34 0.8 ]
          [ 0.34 1 ]
        ])
        (curve "dms_open" [
          [ 0.38 1 ]
          [ 0.22 1 ]
        ])
        (curve "dms_movement" [
          [ 0.38 1.15 ]
          [ 0.22 1 ]
        ])
        (curve "dms_popups" [
          [ 0.38 1.46 ]
          [ 0.22 1 ]
        ])
        (curve "dms_workspace" [
          [ 0.38 1.22 ]
          [ 0.22 1 ]
        ])
      ];

      animation = [
        (animation "global" 3 "dms_fade")

        (animation "windows" 1.5 "dms_open")
        ((animation "windowsIn" 1.5 "dms_open") // {
          style = "popin 80%";
        })
        ((animation "windowsOut" 1.5 "dms_fade") // {
          style = "popin 80%";
        })
        (animation "windowsMove" 4.7 "dms_movement")

        (animation "layers" 3.2 "dms_popups")
        ((animation "layersIn" 3.2 "dms_popups") // {
          style = "popin 90%";
        })
        ((animation "layersOut" 1.5 "dms_fade") // {
          style = "popin 90%";
        })

        (animation "fade" 1.5 "dms_fade")
        (animation "fadeIn" 1.5 "dms_fade")
        (animation "fadeOut" 1.5 "dms_fade")
        (animation "fadeSwitch" 1.5 "dms_fade")
        (animation "fadeShadow" 1.5 "dms_fade")
        (animation "fadeGlow" 1.5 "dms_fade")
        (animation "fadeDim" 1.5 "dms_fade")
        (animation "fadeDpms" 1.5 "dms_fade")

        (animation "fadeLayers" 1.5 "dms_fade")
        (animation "fadeLayersIn" 1.5 "dms_fade")
        (animation "fadeLayersOut" 1.5 "dms_fade")

        (animation "fadePopups" 1.5 "dms_fade")
        (animation "fadePopupsIn" 1.5 "dms_fade")
        (animation "fadePopupsOut" 1.5 "dms_fade")

        (animation "border" 2 "dms_fade")

        (animation "workspaces" 4.3 "dms_workspace")
        (animation "workspacesIn" 4.3 "dms_workspace")
        (animation "workspacesOut" 4.3 "dms_workspace")

        (animation "specialWorkspace" 4.3 "dms_workspace")
        (animation "specialWorkspaceIn" 4.3 "dms_workspace")
        (animation "specialWorkspaceOut" 4.3 "dms_workspace")

        (animation "zoomFactor" 3 "dms_fade")
        (animation "monitorAdded" 3 "dms_fade")

        {
          leaf = "borderangle";
          enabled = false;
        }
      ];
    };
  };
}