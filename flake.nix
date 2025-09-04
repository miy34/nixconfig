{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xwayland-satellite.url = "github:Supreeeme/xwayland-satellite";
  };

  outputs = { self, nixpkgs, home-manager, stylix, xwayland-satellite, ... }: 
    let
       system = "x86_64-linux";
       user = "miy";
    in 
    {
    defaultSystem = system;
    nixosConfigurations = {
      miy-nixos = nixpkgs.lib.nixosSystem {
        system = "${system}";
        modules = [
	  stylix.nixosModules.stylix
          ./filesystem.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager 
	  {
  	      home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.miy = ./home.nix;
	  }
        ];
      };
    };
  };
}
