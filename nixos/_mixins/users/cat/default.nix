{ config, desktop, lib, pkgs, ... }:
let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  # Only include desktop components if one is supplied.
  imports = [ ] ++ lib.optional (builtins.isString desktop) ./desktop.nix;

  environment.systemPackages = [
    #pkgs.yadm # Terminal dot file manager
  ];

  users.users.cat = {
    description = "cat";
    extraGroups = [
      "audio"
      "input"
      "networkmanager"
      "users"
      "video"
      "wheel"
    ]
    ++ ifExists [
      "docker"
      "podman"
    ];
    # mkpasswd -m sha-512 (old standby)
    hashedPassword = "$6$KRxY5K9oteaWBNsK$Es8NdMfUm4CnksfGnLXUVHHDMDeneo7C/oUjYl5rrWtAkm3KBktsouPkit6.W87AfuO4aMW7bxHbmlFyZ/HRk0";
    homeMode = "0755";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
            "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCO4EowU6zM6z0T3dbw4Ovj92DJ6hcFv76vOqqDGxXQV/M5JHG+vxetp1tTnMZMYk98wzZ48g+HfsHzfI607lTI= cat@i7dwarf"
    ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.bash;
  };
}

