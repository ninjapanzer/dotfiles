{ pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;          # "Steam (gamescope)" session at login
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamescope.enable = true;          # gamescope --hdr-enabled -- %command%
  programs.gamemode.enable = true;           # gamemoderun %command%

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
