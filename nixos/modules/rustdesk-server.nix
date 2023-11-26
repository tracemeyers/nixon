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
    environment.systemPackages = with pkgs; [
      unstable.rustdesk-server
    ];

    networking.firewall.allowedTCPPorts = optionals cfg.openFirewall cfg.tcpPorts;
    networking.firewall.allowedUDPPorts = optionals cfg.openFirewall cfg.udpPorts;

    # https://discourse.nixos.org/t/rustdesk-systemd-service-config/34281

    systemd.services.rustdesk-server-relay = {
      description = "Rustdesk Signal Server (hbbr)";
      after = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      partOf = [ "rustdesk-server-rendezvous.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        LimitNOFILE=1000000;
        WorkingDirectory="/opt/rustdesk";
        StandardOutput="append:/var/log/rustdesk/hbbr.log";
        StandardError="append:/var/log/rustdesk/hbbr.error";
        ExecStart="${pkgs.unstable.rustdesk-server}/bin/hbbr";
        Restart="always";
        RestartSec=10;
      };
    };

    systemd.services.rustdesk-server-rendezvous = {
      description = "Rustdesk Rendezvous Server (hbbr)";
      after = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      partOf = [ "rustdesk-server-relay.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        LimitNOFILE=1000000;
        WorkingDirectory="/opt/rustdesk";
        StandardOutput="append:/var/log/rustdesk/hbbs.log";
        StandardError="append:/var/log/rustdesk/hbbs.error";
        ExecStart="${pkgs.unstable.rustdesk-server}/bin/hbbs";
        Restart="always";
        RestartSec=10;
      };
    };

    systemd.tmpfiles.rules = [
      "d /opt/rustdesk 0700 root root"
      "d /var/log/rustdesk 0700 root root"
      # optional (only for [Erase Your Darlings](https://grahamc.com/blog/erase-your-darlings) or [tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/) setups):
      # "L /opt/rustdesk/db_v2.sqlite3 - - - - /persist/opt/rustdesk/db_v2.sqlite3"
      # "L /opt/rustdesk/db_v2.sqlite3-shm - - - - /persist/opt/rustdesk/db_v2.sqlite3-shm"
      # "L /opt/rustdesk/db_v2.sqlite3-wal - - - - /persist/opt/rustdesk/db_v2.sqlite3-wal"
      # "L /opt/rustdesk/id_ed25519 - - - - /persist/opt/rustdesk/id_ed25519"
      # "L /opt/rustdesk/id_ed25519.pub - - - - /persist/opt/rustdesk/id_ed25519.pub"
    ];
  };
}
