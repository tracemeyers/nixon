{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];
    package = pkgs.unstable.firefox;
    policies = {
      DisplayBookmarksToolbar = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      EnableTrackingProtection = true;
    };
  };
}
