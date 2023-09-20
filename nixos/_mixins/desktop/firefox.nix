{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];
    package = pkgs.unstable.firefox;
    policies = {
      DisplayBookmarksToolbar = false;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = true;
    };
  };
}
