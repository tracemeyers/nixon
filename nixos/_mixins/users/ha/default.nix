{
  config,
  desktop,
  lib,
  pkgs,
  ...
}: let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  environment.systemPackages = [
    #pkgs.yadm # Terminal dot file manager
  ];

  users.users.ha = {
    description = "homeassistant";
    extraGroups =
      [
        "oci"
        "users"
      ]
      ++ ifExists [
        "podman"
      ];
    homeMode = "0755";
    isNormalUser = true;
    packages = [];
    shell = pkgs.bash;
  };
}
