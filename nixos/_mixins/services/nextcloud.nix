{
  config,
  pkgs,
  ...
}: {
  #services = {
  #  nextcloud = {
  #    enable = true;
  #    package = pkgs.unstable.nextcloud27;
  #    extraApps = with config.services.nextcloud.package.packages.apps; {
  #      inherit contacts calendar tasks;
  #    };
  #    extraAppsEnable = true;
  #  };
  #};
  private.services.nextcloud = {
    enable = true;
    hostName = "192.168.1.96";
  };
}
