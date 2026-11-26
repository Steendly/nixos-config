{ ... }:

{
  programs.dank-material-shell.settings = {
    dashTabs = [
      {
        id = "overview";
        enabled = true;
      }
      {
        id = "media";
        enabled = true;
      }
      {
        id = "wallpaper";
        enabled = false;
      }
      {
        id = "weather";
        enabled = false;
      }
      {
        id = "notifications";
        enabled = true;
      }
      {
        id = "wellbeing";
        enabled = true;
      }
      {
        id = "settings";
        enabled = false;
      }
    ];

    dashCards = [
      {
        id = "weather";
        w = 1;
        h = 1;
      }
      {
        id = "notifications";
        w = 3;
        h = 4;
        col = 3;
        row = 0;
      }
      {
        id = "calendar";
        w = 3;
        h = 4;
        col = 0;
        row = 1;
      }
      {
        id = "media";
        w = 3;
        h = 1;
        col = 3;
        row = 4;
      }
      {
        id = "cpu";
        w = 2;
        h = 1;
        col = 0;
        row = 0;
      }
      {
        id = "memory";
        w = 1;
        h = 1;
        col = 2;
        row = 0;
      }
    ];
  };
}