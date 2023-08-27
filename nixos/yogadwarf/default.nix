{ inputs, lib, pkgs, ... }:
{
  imports = [
    (import ./disks.nix { })
    ../_mixins/hardware/systemd-boot.nix
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
        "rtsx_pci_sdmmc"
        "sd_mod"
        "sdhci_pci"
        "uas"
        "usbhid"
        "usb_storage"

        "ahci"
        "ehci_pci"
        "rtsx_usb_sdmmc"
        "sd_mod"
        "uas"
        "xhci_pci"
      ];
    };
    kernelModules = [ "kvm-intel" "wl" ];
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
}

