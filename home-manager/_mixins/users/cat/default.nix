{ lib, hostname, username, ... }: {
  imports = [ ]
    ++ lib.optional (builtins.pathExists (./. + "/hosts/${hostname}.nix")) ./hosts/${hostname}.nix;

  home = {
    file.".config/klipperrc".text = "
      [General]
      IgnoreImages=false
      MaxClipItems=99
    ";
  };
  #programs = {
  #  git = {
  #    userEmail = "martin@wimpress.org";
  #    userName = "Martin Wimpress";
  #    signing = {
  #      key = "15E06DA3";
  #      signByDefault = true;
  #    };
  #  };
  #};

  #systemd.user.tmpfiles.rules = [
  #  "d /home/${username}/Audio 0755 ${username} users - -"
  #  "d /home/${username}/Development/debian 0755 ${username} users - -"
  #  "d /home/${username}/Development/DeterminateSystems 0755 ${username} users - -"
  #  "d /home/${username}/Development/flexiondotorg 0755 ${username} users - -"
  #  "d /home/${username}/Development/mate-desktop 0755 ${username} users - -"
  #  "d /home/${username}/Development/NixOS 0755 ${username} users - -"
  #  "d /home/${username}/Development/quickemu-project 0755 ${username} users - -"
  #  "d /home/${username}/Development/restfulmedia 0755 ${username} users - -"
  #  "d /home/${username}/Development/ubuntu 0755 ${username} users - -"
  #  "d /home/${username}/Development/ubuntu-mate 0755 ${username} users - -"
  #  "d /home/${username}/Development/wimpysworld 0755 ${username} users - -"
  #  "d /home/${username}/Dropbox 0755 ${username} users - -"
  #  "d /home/${username}/Games 0755 ${username} users - -"
  #  "d /home/${username}/Quickemu/nixos-console 0755 ${username} users - -"
  #  "d /home/${username}/Quickemu/nixos-desktop 0755 ${username} users - -"
  #  "d /home/${username}/Scripts 0755 ${username} users - -"
  #  "d /home/${username}/Studio/OBS/config/obs-studio/ 0755 ${username} users - -"
  #  "d /home/${username}/Syncthing 0755 ${username} users - -"
  #  "d /home/${username}/Volatile/Vorta 0755 ${username} users - -"
  #  "d /home/${username}/Websites 0755 ${username} users - -"
  #  "d /home/${username}/Zero 0755 ${username} users - -"
  #  "L+ /home/${username}/.config/obs-studio/ - - - - /home/${username}/Studio/OBS/config/obs-studio/"
  #];
}

