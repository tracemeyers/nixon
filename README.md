# Nix Config

WIP - nothing works yet

## Start

flake.nix
- ./nixos/default.nix -> mkHost{ hostname, username, desktop }
	- various configs
  	- env
		- defaultPackages
		- systemPackages
	- imports
		- disko
		- {hostname}
			- disko config
			- boot settings
			- hardware specific settings
			- hardware specific packages
		- ./nixos/_mixins/users/root/default.nix
			- disable password login
			- ssh auth keys
		- ./nixos/_mixins/users/{username}/default.nix
			- system packages
			- user groups
			- initial password (hashed)
			- ssh auth keys
			- packages
			- shell

## Hosts

### proof

Use on a VM as a proof of concept to confirm a config works as planned.

Steps:
1. Install qemu (or quickemu)
2. Download and start a nixos vm:

   Option:
   ```
   $ quickget nixos 22.11
   nixos-22.11-gnome/latest-nixos-gnome-x86_64-linux.iso                 100%[++++++=======================================================
   Checking nixos-22.11-gnome/latest-nixos-gnome-x86_64-linux.iso with sha256sum... Good!
   Making nixos-22.11-gnome.conf
   Giving user execute permissions on nixos-22.11-gnome.conf,

   To start your NixOS virtual machine run:
       quickemu --vm nixos-22.11-gnome.conf
   ```

   ```
   $ nixos-22.11-minimal/latest-nixos-m 100%[==============>] 827.00M  1.08MB/s    in 13m 15s 
   Checking nixos-22.11-minimal/latest-nixos-minimal-x86_64-linux.iso with sha256sum... Good!
   Making nixos-22.11-minimal.conf
   Giving user execute permissions on nixos-22.11-minimal.conf,
   
   To start your NixOS virtual machine run:
       quickemu --vm nixos-22.11-minimal.conf
   
   $ quickemu --vm nixos-22.11-minimal.conf
   Quickemu 4.4 using /nix/store/2jh1zz3vvfwzjblf3g7143y2a64zv9az-qemu-7.1.0/bin/qemu-system-x86_64 v7.1.0
   [...]
   ```
3. ssh and generate the nixos hardware config from within the VM
   ```
   # Need to set the password via qemu first
   $ ssh nixos@localhost -p 22220
   [nixos@nixos:~]$ nixos-generate-config --dir /tmp
   writing /tmp/hardware-configuration.nix...
   writing /tmp/configuration.nix...
   For more hardware-specific settings, see https://github.com/NixOS/nixos-hardware.
   ```
4. Copy the boot settings to ./nixos/proof/default.nix. Ex: copy the fields that contain non-empty values which are the `availableKernelModules` and `kernelModules`.
   ```
   [nixos@nixos:~]$ grep -i boot.*module /tmp/hardware-configuration.nix 
     boot.initrd.availableKernelModules = [ "xhci_pci" "ohci_pci" "ehci_pci" "virtio_pci" "virtio_scsi" "ahci" "usbhid" "sd_mod" "sr_mod" ];
     boot.initrd.kernelModules = [ ];
     boot.kernelModules = [ "kvm-intel" ];
     boot.extraModulePackages = [ ];
   
   ```

5. Download install script and modify it. TODO fork it.
   ```
   [nixos@nixos:~]$ curl -sL https://raw.githubusercontent.com/wimpysworld/nix-config/main/scripts/install.sh -O install.sh
   [nixos@nixos:~]$ sed -i 's,wimpysworld/nix-config,tracemeyers/nixon,g' install.sh
   [nixos@nixos:~]$ sed -i 's,martin,cat,g' install.sh
   [nixos@nixos:~]$ chmod u+x install.sh
   ```
6. Run it
   ```
   [nixos@nixos:~]$ ./install.sh proof cat
   ```

7. After install...

    1. sudo nixos-rebuild switch --flake $HOME/Zero/nix-config

## Credits

wimpysworld
