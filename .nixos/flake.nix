{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
    rhythmboxFixed.url ="github:nixos/nixpkgs/986a0a1a1905b3227b28db009619321105c62464";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    burl.url = "git+https://git.sr.ht/~ninjapanzer/burl?ref=refs/tags/v1.26.0";
    beamlet.url = "git+https://git.sr.ht/~ninjapanzer/beamlet?ref=refs/tags/v0.4.2";
    kwike = {
      url = "sourcehut:~ninjapanzer/kwike";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    keepawake = {
      url = "sourcehut:~ninjapanzer/keepawake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    logseq = {
      url = "github:Bad3r/nix-logseq-git-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgsUnstable,
    rhythmboxFixed,
    burl,
    beamlet,
    zen-browser,
    kwike,
    home-manager,
    logseq,
    claude-code,
    ...
  }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # You should point this to your actual configuration.nix
        ./configuration.nix 
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            backupFileExtension = "bak";
            extraSpecialArgs = { inherit inputs; };
            users.paulscoder = import ./home.nix;
          };
        }
      ];
    };
  };
}
