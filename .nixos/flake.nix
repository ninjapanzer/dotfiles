{
  description = "gaming-rig NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # Same Claude Code source as the laptop. No `follows`: it uses its own
    # pinned nixpkgs, so the binary comes from its cache unchanged.
    claude-code.url = "github:sadjow/claude-code-nix";

    # Own tools, pinned to the same tags as the laptop
    burl.url = "git+https://git.sr.ht/~ninjapanzer/burl?ref=refs/tags/v1.72.0";
    beamlet.url = "git+https://git.sr.ht/~ninjapanzer/beamlet?ref=refs/tags/v0.8.1";
    wavelet.url = "git+https://git.sr.ht/~ninjapanzer/wavelet?ref=refs/tags/v0.6.0-beta";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { nixpkgs, ... }@inputs: {
    # Output name matches networking.hostName, so plain
    # `nixos-rebuild switch` in /etc/nixos picks it automatically.
    nixosConfigurations.gaming-rig = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./configuration.nix ];
    };
  };
}
