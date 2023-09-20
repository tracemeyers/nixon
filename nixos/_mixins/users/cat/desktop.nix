{ desktop, pkgs, lib, ... }: {
  imports = [
    #../../desktop/brave.nix
    #../../desktop/chromium.nix
    # TODO
    ../../desktop/firefox.nix
    #../../desktop/evolution.nix
    #../../desktop/google-chrome.nix
    #../../desktop/microsoft-edge.nix
    #../../desktop/obs-studio.nix
    #../../desktop/opera.nix
    #../../desktop/tilix.nix
    #../../desktop/vivaldi.nix
    #../../desktop/vscode.nix
  ] ++ lib.optional (builtins.pathExists (../.. + "/desktop/${desktop}-apps.nix")) ../../desktop/${desktop}-apps.nix;

  environment.systemPackages = with pkgs; [
    #audio-recorder
    #authy
    #chatterino2
    #cider
    #gimp-with-plugins
    #gnome.gnome-clocks
    #gnome.dconf-editor
    #gnome.gnome-sound-recorder
    #irccloud
    #inkscape
    #libreoffice
    #meld
    #netflix
    #pick-colour-picker
    #rhythmbox
    #shotcut
    #slack
    #zoom-us

    ## Fast moving apps use the unstable branch
    #unstable.discord
    #unstable.fluffychat
    #unstable.gitkraken
    #unstable.tdesktop
    #unstable.wavebox

    unstable.neovim
  ];

  #programs = {
  #  chromium = {
  #    extensions = [
  #      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
  #      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
  #      "mdjildafknihdffpkfmmpnpoiajfjnjd" # Consent-O-Matic
  #      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube
  #      "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube Dislike
  #      "edlifbnjlicfpckhgjhflgkeeibhhcii" # Screenshot Tool
  #    ];
  #  };
  #};
  programs.firefox.policies = {
    DisplayBookmarksToolbar = false;
    DisablePocket = true;
    DontCheckDefaultBrowser = true;
    EnableTrackingProtection = true;
    # To find the extension id, install it then go to about:support. Kind of dumb but :shrug:
    ExtensionSettings = {
      "uBlock0@raymondhill.net" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      };
      "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
        installation_mode = "normal_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        default_area = "navbar";
      };
      "@testpilot-containers" = {
        installation_mode = "normal_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
        default_area = "navbar";
      };
      "{3c078156-979c-498b-8990-85f7987dd929}" = {
        installation_mode = "normal_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
        #default_area = "navbar";
      };
      "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
        installation_mode = "normal_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/auto-tab-discard/latest.xpi";
        #default_area = "navbar";
      };
      "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
        installation_mode = "normal_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
        default_area = "navbar";
      };
    };
  };
}
