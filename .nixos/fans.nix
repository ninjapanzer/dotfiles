{ config, ... }:
let
  # ITE IT8696E Super I/O: only the out-of-tree it87 driver supports it.
  # nixpkgs installs it87.ko beside the in-tree it87.ko.xz at the same
  # path, and depmod resolves the in-tree one (no IT8696E support).
  # Move ours to updates/, which depmod searches before built-in modules.
  it87 = config.boot.kernelPackages.it87.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      d=$out/lib/modules/${config.boot.kernelPackages.kernel.modDirVersion}
      mkdir -p $d/updates
      mv $d/kernel/drivers/hwmon/it87.ko $d/updates/
    '';
  });
in
{
  # Headers stay on the BIOS curve (pwm*_enable=2) until CoolerControl
  # is told otherwise.
  boot.extraModulePackages = [ it87 ];
  boot.kernelModules = [ "it87" ];
  boot.extraModprobeConfig = "options it87 ignore_resource_conflict=1";

  programs.coolercontrol.enable = true;
}
