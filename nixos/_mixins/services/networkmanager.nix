_:
{
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        # iwd is an alternative to wpasupplicant
        backend = "iwd";
      };
    };
  };
  # Workaround https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;
}
