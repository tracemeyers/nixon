{ pkgs, ... }: {
  imports = [
    #./qt-style.nix
    ../services/networkmanager.nix
  ];

  # Exclude MATE themes. Yaru will be used instead.
  # Don't install mate-netbook or caja-dropbox
  environment = {
    plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa # media player
    ];
    ## Add some packages to complete the desktop
    #systemPackages = with pkgs; [
    #  networkmanagerapplet
    #];
  };

  ## Enable some programs to provide a complete desktop
  #programs = {
  #  nm-applet.enable = true;
  #  system-config-printer.enable = true;
  #};

  # Enable services to round out the desktop
  services = {
    #blueman.enable = true;
    #gnome.gnome-keyring.enable = true;
    #gvfs.enable = true;
    system-config-printer.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        sddm.enable = true;
      };

      desktopManager = {
        plasma5.enable = true;
      };
    };
  };
  #xdg.portal.extraPortals = [ xdg-desktop-portal-kde ];
}

