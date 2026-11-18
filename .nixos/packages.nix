{ pkgs, inputs, ... }:
let
  sys = pkgs.stdenv.hostPlatform.system;
in
with pkgs; [
  vim
  gitFull
  inputs.claude-code.packages.${sys}.default
  inputs.burl.packages.${sys}.default
  inputs.burl.packages.${sys}.burl-mcp
  inputs.burl.packages.${sys}.burl-backend
  inputs.beamlet.packages.${sys}.beamlet
  inputs.wavelet.packages.${sys}.default
  inputs.zen-browser.packages.${sys}.default
  cachix
  vcsh
  yq-go
  bitwarden-desktop
  pciutils
  usbutils
]
