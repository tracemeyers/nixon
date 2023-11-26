{ inputs, lib, pkgs, ... }:
{
  imports = [
    (import ./disks.nix { })
    ../_mixins/hardware/systemd-boot.nix
    ../_mixins/users/tby
    ../_mixins/services/docker.nix
    #../_mixins/services/rustdesk-server.nix
    #../_mixins/services/pipewire.nix
    #../_mixins/virt
  ];

  swapDevices = [{
    device = "/swap";
    size = 2048;
  }];

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
    kernelModules = [ "kvm-amd" "amdgpu" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  services.kmscon.extraConfig = lib.mkForce ''
    font-size=18
    xkb-layout=us
  '';

  environment.systemPackages = with pkgs; [
    #nvtop-amd
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  services.xserver.videoDrivers = [ "amdgpu" ];
}

