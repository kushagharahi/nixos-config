{pkgs, ...}: let
  # smb mount opts variable
  smbOptions = [
    "credentials=/home/kusha/nixos-config/secrets/netdisk-secret"
    "uid=1000"
    "gid=100"
    "rw"
    "vers=3.0"
    "x-systemd.automount" # This makes it "lazy load" like Windows
    "noauto"
    "x-systemd.idle-timeout=60" # Unmounts when not in use to save resources
  ];
in {
  environment.systemPackages = [pkgs.cifs-utils];

  # Mount homelab smb
  fileSystems."/mnt/netdisk/home" = {
    device = "//192.168.1.23/home";
    fsType = "cifs";
    options = smbOptions;
  };

  fileSystems."/mnt/netdisk/media" = {
    device = "//192.168.1.23/Media";
    fsType = "cifs";
    options = smbOptions;
  };

  fileSystems."/mnt/netdisk/docker" = {
    device = "//192.168.1.23/docker";
    fsType = "cifs";
    options = smbOptions;
  };

  fileSystems."/mnt/netdisk/photos" = {
    device = "//192.168.1.23/photo-frame";
    fsType = "cifs";
    options = smbOptions;
  };

  # Local NTFS storage drive
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/1892489E9248826C";
    fsType = "ntfs3";
    options = [
      "nofail"
      "uid=1000"
      "gid=100"
      "rw"
      "user"
      "exec" # Explicitly allow executing binaries (critical for Steam)
      "umask=000" # Simplest way to give full access; or use dmask=000,fmask=000
      #"windows_names" # Prevents creating files with names Windows doesn't like
    ];
  };
}
