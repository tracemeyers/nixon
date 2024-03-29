{pkgs, ...}: {
  environment.systemPackages = with pkgs.unstable; [
    chromium
  ];

  programs.chromium = {
    enable = true;
  };
}
