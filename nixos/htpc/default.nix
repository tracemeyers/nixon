{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    (import ./disks.nix {})
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/users/tby
    ../_mixins/users/ha
    ../_mixins/services/bluetooth.nix
    ../_mixins/services/docker.nix
    ../_mixins/services/podman.nix
    #../_mixins/services/nextcloud.nix
    ../_mixins/services/rustdesk-server.nix
    ../_mixins/services/pipewire.nix
    #../_mixins/virt
  ];

  swapDevices = [
    {
      device = "/swap";
      size = 2048;
    }
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "uas"
        "sd_mod"
      ];
    };
    kernelModules = ["kvm-amd" "amdgpu"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.kmscon.extraConfig = lib.mkForce ''
    font-size=18
    xkb-layout=us
  '';

  environment.systemPackages = with pkgs; [
    #nvtop-amd
    #unstable.rustdesk
    openscad
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.xserver.videoDrivers = ["amdgpu"];

  networking.networkmanager.wifi.powersave = false;

  networking.nat = {
    enable = true;
    internalInterfaces = ["ve-+"];
    #externalInterface = "wlan0";
    # Lazy IPv6 connectivity for the container
    enableIPv6 = true;
  };

  services.tailscale = {
    enable = true;
  };

  containers.nextcloud = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";

    enableTun = true;
    #bindMounts = {
    #  "/dev/net/tun" = {
    #    hostPath = "/dev/net/tun";
    #    isReadOnly = false;
    #  };
    #};

    #bindMounts = {
    #  "/etc/resolv.conf" = {
    #    hostPath = "/etc/resolv.conf";
    #    isReadOnly = true;
    #  };
    #};

    config = {
      config,
      pkgs,
      ...
    }: {
      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud27;
        hostName = "nextcloud";
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}"; # DON'T DO THIS IN PRODUCTION - the password file will be world-readable in the Nix Store!
      };

      system.stateVersion = "23.04";

      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [80];
        };
        nameservers = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;

      services.tailscale = {
        enable = true;
        #  openFirewall = true;
        authKeyFile = builtins.toFile "authKeyFile" "tskey-auth-kHnTaP2CNTRL-5idEazsPL6bY1Js87Hnuzaj7bPP5QotZ";
      };
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = [
        "home-assistant:/config"
        "/var/run/dbus:/run/dbus:ro" # bluetooth
      ];
      environment.TZ = "Europe/Berlin";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [
        "--network=host"
        #"--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
      ];
    };
  };
  #systemd.services.podman-homeassistant.serviceConfig = {
  #  User = "ha";
  #  WorkingDirectory = "/home/ha";
  #};

  #containers.home-assistant = {
  #  autoStart = true;
  #  privateNetwork = true;
  #  hostAddress = "192.168.100.20";
  #  localAddress = "192.168.100.21";
  #  hostAddress6 = "fc00::20";
  #  localAddress6 = "fc00::21";
  #  enableTun = true;

  #  config = {
  #    config,
  #    pkgs,
  #    ...
  #  }: {
  #    system.stateVersion = "23.11";

  #    services = {
  #      home-assistant = {
  #        enable = true;
  #        openFirewall = true;
  #        config = {
  #          default_config = {};
  #          #homeassistant.time_zone = "America/Chicago";
  #          http = {
  #            #server_port = 80;
  #          };

  #          name = "Home";
  #          latitude = "30.564860766190062";
  #          longitude = "-97.80573264024224";
  #          elevation = "300";
  #          unit_system = "metric";
  #          time_zone = "America/Chicago";
  #        };
  #      };
  #      tailscale = {
  #        enable = true;
  #        extraUpFlags = ["--auth-key" "tskey-auth-kaAn9e5CNTRL-nSCr6vgAtmVdgroMtyRLsVGyBMFr9BkP"];
  #      };
  #    };

  #    networking = {
  #      firewall = {
  #        enable = true;
  #        #allowedTCPPorts = [80 8123];
  #      };

  #      nameservers = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];

  #      # Use systemd-resolved inside the container
  #      # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
  #      useHostResolvConf = lib.mkForce false;
  #    };
  #    services.resolved.enable = true;

  #    # https://tailscale.com/blog/nixos-minecraft
  #    #systemd.services.tailscale-autoconnect = {
  #    #  description = "Automatic connection to Tailscale";

  #    #  # make sure tailscale is running before trying to connect to tailscale
  #    #  after = ["network-pre.target" "tailscale.service"];
  #    #  wants = ["network-pre.target" "tailscale.service"];
  #    #  wantedBy = ["multi-user.target"];

  #    #  # set this service as a oneshot job
  #    #  serviceConfig.Type = "oneshot";

  #    #  # have the job run this shell script
  #    #  script = with pkgs; ''
  #    #    # wait for tailscaled to settle
  #    #    sleep 2

  #    #    # check if we are already authenticated to tailscale
  #    #    status="$(${tailscale}/bin/tailscale status --json | ${jq}/bin/jq -r .BackendState)"
  #    #    if [ $status = "Running" ]; then # if so, then do nothing
  #    #      exit 0
  #    #    fi

  #    #    # otherwise authenticate with tailscale
  #    #    ${tailscale}/bin/tailscale up
  #    #  '';
  #    #};
  #  };
  #};
}
