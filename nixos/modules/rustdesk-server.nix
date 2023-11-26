{ lib, pkgs, config, ... }:
with lib;                      
let
  cfg = config.services.rustdesk-server;
in {
  options.services.rustdesk-server = {
    enable = mkEnableOption "rustdesk-server service";
    openFirewall = mkOption {
      type = types.bool;
      default = true;
    };
    tcpPorts = mkOption {
      type = types.listOf types.port;
      default = [ 8000 21115 21116 21117 21118 21119 ];
        description = lib.mdDoc ''
          Specifies on which TCP ports to listen.
        '';
    };
    udpPorts = mkOption {
      type = types.listOf types.port;
      default = [ 21116 ];
        description = lib.mdDoc ''
          Specifies on which UDP ports to listen.
        '';
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = optionals cfg.openFirewall cfg.tcpPorts;
    networking.firewall.allowedUDPPorts = optionals cfg.openFirewall cfg.udpPorts;
  };
}
