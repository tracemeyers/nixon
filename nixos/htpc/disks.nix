{ disks ? [ "/dev/nvme0n1" ], ... }:
{
  disko.devices = {
    disk = {
      nvme0 = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [{
            name = "ESP";
            start = "0%";
            end = "550MiB";
            bootable = true;
            flags = [ "esp" ];
            fs-type = "fat32";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "root";
            start = "550MiB";
            end = "100%";
            content = {
              type = "filesystem";
              extraArgs = [ ];
              format = "ext4";
              mountpoint = "/";
            };
          }];
        };
      };
    };
  };
}
