# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/profiles/qemu-guest.nix" ];
  boot.zfs.requestEncryptionCredentials = true;
  ragon.system.fs.enable = true;
  ragon.system.fs.nix = "rpool/nix";
  ragon.system.fs.varlog = "rpool/varlog";
  ragon.system.fs.persistent = "rpool/persist";
  ragon.system.fs.swap = false;
  ragon.system.fs.mediadata = false;
  swapDevices = [
    { device = "/dev/sda2"; randomEncryption.enable = true; }
  ];
  services.syncoid.enable = false; # disable failing zfs syncing
  boot.initrd = {
    network = {
      enable = true;
      postCommands = ''
        zpool import rpool
        echo "zfs load-key -a; killall zfs" >> /root/.profile
      '';
      ssh = {
        enable = true;
        port = 2222;
        hostKeys = [
          "/persistent/etc/nixos/secrets/initrd/ssh_host_rsa_key"
          "/persistent/etc/nixos/secrets/initrd/ssh_host_ed25519_key"
        ];
        authorizedKeys = pkgs.pubkeys.ragon.user;

      };

    };

  };

  powerManagement.cpuFreqGovernor = "performance";
}
