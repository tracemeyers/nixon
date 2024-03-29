{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];
    package = pkgs.unstable.firefox;
    policies = {
      Containers = {
        Default = [
          {
            name = "default";
            icon = "pet";
            color = "turquoise";
          }
          {
            name = "tby";
            icon = "pet";
            color = "yellow";
          }
        ];
      };
      DisplayBookmarksToolbar = false;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = true;
    };
  };
}
