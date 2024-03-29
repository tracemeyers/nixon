{
  config,
  desktop,
  lib,
  pkgs,
  ...
}: let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # Only include desktop components if one is supplied.
  imports = [] ++ lib.optional (builtins.isString desktop) ./desktop.nix;

  environment.systemPackages = [
    #pkgs.yadm # Terminal dot file manager
  ];

  users.users.cat = {
    description = "cat";
    extraGroups =
      [
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
      "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAF54C3aDa0g/WMJQizOHOgOtznfsRehs2Xs4cBhXTbspxUH6eojTmhm9643DTQckyOqNzjbvrbsZUlYZtFc0pfl9QHKgeeVFqLTw262CM4Iyb2z5crJBzk9XAN7yoSrcNyDuf2h0ejSofPRQNCQgEOiCt5Bd0fIOkdYkowyML/LA7Da8g=="
    ];
    packages = [pkgs.home-manager];
    shell = pkgs.bash;
  };
}
