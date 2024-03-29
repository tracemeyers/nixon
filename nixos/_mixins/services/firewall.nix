{
  lib,
  hostname,
  ...
}: let
  # Firewall configuration variable for syncthing
  syncthing = {
    hosts = [
      "htpc"
    ];
    tcpPorts = [22000];
    udpPorts = [22000 21027];
  };
in {
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts =
        # TODO can this be added to nginx config?
        [80]
        #++ lib.optionals rustdesk.tcpPorts
        ++ lib.optionals (builtins.elem hostname syncthing.hosts) syncthing.tcpPorts;
      allowedUDPPorts =
        []
        #++ lib.optionals rustdesk.udpPorts
        ++ lib.optionals (builtins.elem hostname syncthing.hosts) syncthing.udpPorts;
    };
  };
}
