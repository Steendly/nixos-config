{ lib, pkgs, ... }: # see: https://discourse.nixos.org/t/hyprland-inefficiet-lua-config/78217

let
  lua = lib.generators.mkLuaInline;
  toLua = lib.generators.toLua { };

  bindWith = key: action: options: {
    _args = [ key (lua action) ] ++ options;
  };
  bind = key: action: bindWith key action [ ];
  bindOpts = key: action: options: bindWith key action [ options ];

  exec = cmd: "hl.dsp.exec_cmd(${toLua cmd})";
  focus = target: "hl.dsp.focus(${toLua target})";

  withGeometryEvent = action: ''
    function()
      hl.dispatch(${action})
      hl.dispatch(hl.dsp.event("dms:geometry"))
    end
  '';

  move = target: withGeometryEvent "hl.dsp.window.move(${toLua target})";
  fullscreen = mode: action: "hl.dsp.window.fullscreen(${toLua { inherit mode action; }})";
  resize = x: y: withGeometryEvent "hl.dsp.window.resize(${toLua { inherit x y; relative = true; }})";
  layout = action: "hl.dsp.layout(${toLua action})";

  terminal = lib.getExe pkgs.kitty;
  locked = { locked = true; };
  lockedRepeating = locked // { repeating = true; };
  repeating = { repeating = true; };
in
{
  wayland.windowManager.hyprland = {
    settings = {
      bind = [
        # Application Launchers
        (bind "SUPER + T" (exec terminal))
        (bind "SUPER + Return" (exec terminal))
        (bind "SUPER + space" (exec "dms ipc call spotlight toggle"))
        (bind "ALT + space" (exec "dms ipc call spotlight-bar toggle"))
        (bind "SUPER + V" (exec "dms ipc call clipboard toggle"))
        (bind "SUPER + M" (exec "dms ipc call dash toggle media"))
        (bind "SUPER + comma" (exec "dms ipc call settings focusOrToggle"))
        (bind "SUPER + N" (exec "dms ipc call notepad toggle"))
        (bind "SUPER + SHIFT + N" (exec "dms ipc call notepad toggleExpand"))
        (bind "SUPER + CTRL + N" (exec "dms ipc call notifications toggle"))
        (bind "SUPER + Y" (exec "dms ipc call dash toggle wallpaper"))
        (bind "SUPER + TAB" (exec "dms ipc call hypr toggleOverview"))
        (bind "SUPER + O" (exec "dms ipc call hypr toggleOverview"))
        (bind "SUPER + X" (exec "dms ipc call powermenu toggle"))
        (bind "SUPER + A" (exec "dms ipc call control-center toggle"))
        (bind "SUPER + D" (exec ''dms ipc call dash toggle ""''))
        (bind "SUPER + SHIFT + C" (exec "dms ipc call color-picker toggle"))
        (bind "SUPER + ALT + N" (exec "dms ipc call night toggle"))
        (bind "SUPER + ALT + I" (exec "dms ipc call inhibit toggle"))
        (bind "SUPER + SHIFT + E" (exec "dms ipc call powermenu toggle"))
        (bind "CTRL + ALT + Delete" (exec "dms ipc call processlist focusOrToggle"))
        (bind "CTRL + ALT + M" (exec "dms ipc call processlist focusOrToggle"))

        # Cheat sheet
        (bind "SUPER + SHIFT + Slash" (exec "dms ipc call keybinds toggle hyprland"))

        # Security
        (bind "SUPER + ALT + L" (exec "dms ipc call lock lock"))

        # Audio Controls
        (bindOpts "XF86AudioRaiseVolume" (exec "dms ipc call audio increment 3") lockedRepeating)
        (bindOpts "XF86AudioLowerVolume" (exec "dms ipc call audio decrement 3") lockedRepeating)
        (bindOpts "XF86AudioMute" (exec "dms ipc call audio mute") locked)
        (bindOpts "XF86AudioMicMute" (exec "dms ipc call audio micmute") locked)
        (bindOpts "XF86AudioPause" (exec "dms ipc call mpris playPause") locked)
        (bindOpts "XF86AudioPlay" (exec "dms ipc call mpris playPause") locked)
        (bindOpts "XF86AudioPrev" (exec "dms ipc call mpris previous") locked)
        (bindOpts "XF86AudioNext" (exec "dms ipc call mpris next") locked)
        (bindOpts "CTRL + XF86AudioRaiseVolume" (exec "dms ipc call mpris increment 3") lockedRepeating)
        (bindOpts "CTRL + XF86AudioLowerVolume" (exec "dms ipc call mpris decrement 3") lockedRepeating)

        # Brightness Controls
        (bindOpts "XF86MonBrightnessUp" (exec ''dms ipc call brightness increment 5 ""'') lockedRepeating)
        (bindOpts "XF86MonBrightnessDown" (exec ''dms ipc call brightness decrement 5 ""'') lockedRepeating)

        # Window Management
        (bind "SUPER + Q" "hl.dsp.window.close()")
        (bind "SUPER + F" (fullscreen "maximized" "toggle"))
        (bind "SUPER + SHIFT + F" (fullscreen "fullscreen" "toggle"))
        (bind "SUPER + SHIFT + T" ''hl.dsp.window.float({ action = "toggle" })'')
        (bind "SUPER + W" "hl.dsp.group.toggle()")
        (bind "SUPER + SHIFT + W" (exec "dms ipc call window-rules toggle"))

        # Focus Navigation
        (bind "SUPER + left" (focus { direction = "l"; }))
        (bind "SUPER + down" (focus { direction = "d"; }))
        (bind "SUPER + up" (focus { direction = "u"; }))
        (bind "SUPER + right" (focus { direction = "r"; }))
        (bind "SUPER + H" (focus { direction = "l"; }))
        (bind "SUPER + J" (focus { direction = "d"; }))
        (bind "SUPER + K" (focus { direction = "u"; }))
        (bind "SUPER + L" (focus { direction = "r"; }))

        # Window Movement
        (bind "SUPER + SHIFT + left" (move { direction = "l"; }))
        (bind "SUPER + SHIFT + down" (move { direction = "d"; }))
        (bind "SUPER + SHIFT + up" (move { direction = "u"; }))
        (bind "SUPER + SHIFT + right" (move { direction = "r"; }))
        (bind "SUPER + SHIFT + H" (move { direction = "l"; }))
        (bind "SUPER + SHIFT + J" (move { direction = "d"; }))
        (bind "SUPER + SHIFT + K" (move { direction = "u"; }))
        (bind "SUPER + SHIFT + L" (move { direction = "r"; }))

        # Column Navigation
        (bind "SUPER + Home" (focus { window = "first"; }))
        (bind "SUPER + End" (focus { window = "last"; }))

        # Monitor Navigation
        (bind "SUPER + CTRL + left" (focus { monitor = "l"; }))
        (bind "SUPER + CTRL + right" (focus { monitor = "r"; }))
        (bind "SUPER + CTRL + H" (focus { monitor = "l"; }))
        (bind "SUPER + CTRL + J" (focus { monitor = "d"; }))
        (bind "SUPER + CTRL + K" (focus { monitor = "u"; }))
        (bind "SUPER + CTRL + L" (focus { monitor = "r"; }))

        # Move to Monitor
        (bind "SUPER + SHIFT + CTRL + left" (move { monitor = "l"; }))
        (bind "SUPER + SHIFT + CTRL + down" (move { monitor = "d"; }))
        (bind "SUPER + SHIFT + CTRL + up" (move { monitor = "u"; }))
        (bind "SUPER + SHIFT + CTRL + right" (move { monitor = "r"; }))
        (bind "SUPER + SHIFT + CTRL + H" (move { monitor = "l"; }))
        (bind "SUPER + SHIFT + CTRL + J" (move { monitor = "d"; }))
        (bind "SUPER + SHIFT + CTRL + K" (move { monitor = "u"; }))
        (bind "SUPER + SHIFT + CTRL + L" (move { monitor = "r"; }))

        # Workspace Navigation
        (bind "SUPER + Page_Down" (focus { workspace = "e+1"; }))
        (bind "SUPER + Page_Up" (focus { workspace = "e-1"; }))
        (bind "SUPER + U" (focus { workspace = "e+1"; }))
        (bind "SUPER + I" (focus { workspace = "e-1"; }))
        (bind "SUPER + CTRL + down" (move { workspace = "e+1"; }))
        (bind "SUPER + CTRL + up" (move { workspace = "e-1"; }))
        (bind "SUPER + CTRL + U" (move { workspace = "e+1"; }))
        (bind "SUPER + CTRL + I" (move { workspace = "e-1"; }))

        # Workspace Management
        (bind "SUPER + ALT + R" (exec "dms ipc call workspace-rename open"))

        # Scratchpad
        (bind "SUPER + S" "hl.dsp.workspace.toggle_special()")
        (bind "SUPER + SHIFT + S" (move { workspace = "special"; follow = false; }))
        (bind "SUPER + CTRL + S" (move { workspace = "+0"; }))

        # Move Workspaces
        (bind "SUPER + SHIFT + Page_Down" (move { workspace = "e+1"; }))
        (bind "SUPER + SHIFT + Page_Up" (move { workspace = "e-1"; }))
        (bind "SUPER + SHIFT + U" (move { workspace = "e+1"; }))
        (bind "SUPER + SHIFT + I" (move { workspace = "e-1"; }))

        # Mouse Wheel Navigation
        (bind "SUPER + mouse_down" (focus { workspace = "e+1"; }))
        (bind "SUPER + mouse_up" (focus { workspace = "e-1"; }))
        (bind "SUPER + CTRL + mouse_down" (move { workspace = "e+1"; }))
        (bind "SUPER + CTRL + mouse_up" (move { workspace = "e-1"; }))

        # Numbered Workspaces
        (bind "SUPER + 1" (focus { workspace = "1"; }))
        (bind "SUPER + 2" (focus { workspace = "2"; }))
        (bind "SUPER + 3" (focus { workspace = "3"; }))
        (bind "SUPER + 4" (focus { workspace = "4"; }))
        (bind "SUPER + 5" (focus { workspace = "5"; }))
        (bind "SUPER + 6" (focus { workspace = "6"; }))
        (bind "SUPER + 7" (focus { workspace = "7"; }))
        (bind "SUPER + 8" (focus { workspace = "8"; }))
        (bind "SUPER + 9" (focus { workspace = "9"; }))

        # Move to Numbered Workspaces
        (bind "SUPER + SHIFT + 1" (move { workspace = "1"; }))
        (bind "SUPER + SHIFT + 2" (move { workspace = "2"; }))
        (bind "SUPER + SHIFT + 3" (move { workspace = "3"; }))
        (bind "SUPER + SHIFT + 4" (move { workspace = "4"; }))
        (bind "SUPER + SHIFT + 5" (move { workspace = "5"; }))
        (bind "SUPER + SHIFT + 6" (move { workspace = "6"; }))
        (bind "SUPER + SHIFT + 7" (move { workspace = "7"; }))
        (bind "SUPER + SHIFT + 8" (move { workspace = "8"; }))
        (bind "SUPER + SHIFT + 9" (move { workspace = "9"; }))

        # Column Management
        (bind "SUPER + bracketleft" (layout "preselect l"))
        (bind "SUPER + bracketright" (layout "preselect r"))

        # Sizing & Layout
        (bind "SUPER + R" (layout "togglesplit"))
        (bind "SUPER + CTRL + F" (fullscreen "maximized" "set"))

        # Move/resize windows with mainMod + LMB/RMB and dragging
        (bindOpts "SUPER + mouse:272" "hl.dsp.window.drag()" { mouse = true; description = "Move window"; })
        (bindOpts "SUPER + mouse:273" "hl.dsp.window.resize()" { mouse = true; description = "Resize window"; })

        # Manual Sizing
        (bindOpts "SUPER + minus" (resize (-100) 0) repeating)
        (bindOpts "SUPER + equal" (resize 100 0) repeating)
        (bindOpts "SUPER + SHIFT + minus" (resize 0 (-100)) repeating)
        (bindOpts "SUPER + SHIFT + equal" (resize 0 100) repeating)

        # Screenshots
        (bind "Print" (exec "dms screenshot"))
        (bind "CTRL + Print" (exec "dms screenshot full"))
        (bind "ALT + Print" (exec "dms screenshot window"))

        # Display Profiles
        (bind "SUPER + P" (exec "dms ipc outputs cycleProfile"))

        # System Controls
        (bind "SUPER + SHIFT + P" ''hl.dsp.dpms({ action = "toggle" })'')
      ];

      gesture = {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      };
    };
  };
}
