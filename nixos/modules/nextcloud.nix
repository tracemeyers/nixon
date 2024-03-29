{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.private.services.nextcloud;
in {
  options.private.services.nextcloud = {
    enable = mkEnableOption "private.services.nextcloud";

    hostName = mkOption {
      default = "localhost";
      description = "hostname - e.g. nextcloud.mydomain.com";
      type = types.str;
    };

    password = mkOption {
      default = "Next@Cloud9";
      description = "Password for the 'root' user";
      type = types.str;
    };

    openFirewall = mkOption {
      type = types.bool;
      default = true;
    };
    tcpPorts = mkOption {
      type = types.listOf types.port;
      default = [80 443];
      description = lib.mdDoc ''
        Specifies which TCP ports to listen on.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud27;
      hostName = cfg.hostName;

      database.createLocally = true;

      # NOTE: services.nextcloud.config is only used for the initial setup, afterwards Nextcloud's stateful config takes precedence
      config = {
        dbtype = "pgsql";
        dbuser = "nextcloud";
        dbname = "nextcloud";
        adminpassFile = builtins.toFile "root-password" cfg.password;
        adminuser = "root";
        #overwriteProtocol = "https";
        defaultPhoneRegion = "US";
      };
    };

    #openFirewall = mkOption {
    #  type = types.bool;
    #  default = true;
    #};
    networking.firewall.allowedTCPPorts = optionals cfg.openFirewall cfg.tcpPorts;

    services.nginx.virtualHosts.${cfg.hostName} = {
      #forceSSL = true;
      #enableACME = true;

      #extraConfig = ''
      #  add_header Strict-Transport-Security "max-age=15768000; includeSubDomains" always; # six months
      #'';
      # NOTE: the rest is configured by services.nextcloud.enable
    };

    services.postgresql = {
      package = pkgs.unstable.postgresql_16;
      dataDir = "/var/lib/postgresql/16";
    };
  };
}
