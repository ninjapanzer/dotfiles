{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";
    rhythmboxFixed.url ="github:nixos/nixpkgs/986a0a1a1905b3227b28db009619321105c62464";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgsUnstable, rhythmboxFixed, zen-browser, home-manager, ... }@inputs: {
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
