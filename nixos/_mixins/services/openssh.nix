{ lib, ... }: {
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = lib.mkDefault "no";
      };
    };
    sshguard = {
      enable = true;
      whitelist = [
        "192.168.1.0/24"
        "192.168.192.0/24"
        "10.0.0.0/16"
      ];
    };
  };
  programs.ssh.startAgent = true;
}
