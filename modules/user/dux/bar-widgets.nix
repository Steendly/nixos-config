{ ... }:

{
  programs.dank-material-shell.settings = {
    barConfigs = [
      {
        id = "default";
        name = "Main Bar";
        enabled = true;
        position = 0;
        screenPreferences = [ "all" ];
        showOnLastDisplay = true;

        leftWidgets = [
          {
            id = "workspaceSwitcher";
            enabled = true;
            workspaceIndicatorStyle = "dots";
            showWorkspaceApps = true;
            maxWorkspaceIcons = 1;
            showSpecialWorkspaces = false;
            showWorkspacePadding = true;
            workspacePaddingCount = 5;
            groupActiveWorkspaceApps = false;
            workspaceActiveAppHighlightEnabled = false;
            workspaceUnfocusedAppsFullOpacity = false;
            workspaceFollowFocus = false;
            workspaceFocusedBorderEnabled = false;
            showOccupiedWorkspacesOnly = false;
            workspaceAppIconSizeOffset = 0;
            showWorkspaceName = false;
            showWorkspaceIndex = false;
            workspaceIndicatorRoundness = -1;
            workspaceIndicatorCompact = false;
            overflowMode = "section";
          }
          {
            id = "focusedWindow";
            enabled = true;
            background = false;
          }
        ];

        centerWidgets = [
          "music"
          "clock"
        ];

        rightWidgets = [
          "systemTray"
          # "cpuUsage"
          # "memUsage"
          "notificationButton"
          "battery"
          "controlCenterButton"
        ];

        spacing = 4;
        innerPadding = 2;
        barInsetPadding = -1;
        barLengthPadding = 0;
        barLengthMode = "full";
        barLengthPercent = 80;
        bottomGap = 0;
        attachToScreenEdge = false;
        followInterfaceStyle = true;
        transparency = 1;
        surfaceColor = "default";
        surfaceCustomColor = "#6750A4";

        widgetFollowInterfaceStyle = true;
        widgetTransparency = 1;
        squareCorners = false;
        noBackground = false;
        widgetStyle = "pills";
        maximizeWidgetIcons = false;
        maximizeWidgetText = false;
        widgetPadding = 8;
        batteryColorMode = "theme";

        gothCornersEnabled = false;
        gothCornerRadiusOverride = false;
        gothCornerRadiusValue = 12;

        borderEnabled = false;
        borderColor = "surfaceText";
        borderOpacity = 1;
        borderThickness = 1;

        widgetOutlineEnabled = false;
        widgetOutlineColor = "primary";
        widgetOutlineOpacity = 1;
        widgetOutlineThickness = 1;

        fontScale = 1;
        iconScale = 1;

        autoHide = false;
        autoHideStrict = false;
        autoHideDelay = 250;
        showOnWindowsOpen = false;
        openOnOverview = false;
        visible = true;

        popupGapsAuto = true;
        popupGapsManual = 4;
        maximizeDetection = true;
        useOverlayLayer = false;
        hideOnFullscreen = false;

        scrollEnabled = true;
        scrollXBehavior = "focusWindow";
        scrollYBehavior = "workspace";
        middleClickAction = "none";
        rightClickAction = "none";
        clickActionFollowMouse = false;

        shadowIntensity = 0;
        shadowOpacity = 60;
        shadowColorMode = "default";
        shadowCustomColor = "#000000";
        shadowDirectionMode = "inherit";
        shadowDirection = "top";

        clickThrough = false;
        hoverPopouts = false;
        hoverPopoutDelay = 150;
      }
    ];
  };
}