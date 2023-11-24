{ disks ? [ "/dev/nvme0n1" ], ... }:
{
  disko.devices = {
    disk = {
      nvme0 = {
        type = "disk";
        device = builtins.elemat disks 0;
        content = {
          type = "table";
          format = "gpt";
          partitions = [{
            name = "esp";
            start = "0%";
            end = "550mib";
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
            start = "550mib";
            end = "100%";
            content = {
              type = "filesystem";
              # overwirte the existing filesystem
              extraargs = [ "-f" ];
              format = "ext4";
              mountpoint = "/";
            };
          }];
        };
      };
    };
  };
}
