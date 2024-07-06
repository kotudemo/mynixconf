{
    description = "actually, stock but good reference flake xd";
    
    inputs = {
        nixpkgs = { 
            url = "github:nixos/nixpkgs/nixos-unstable";
            follows = "nixpkgs";
        };

        nixpkgs-master = {
            url = "github:nixos/nixpkgs/master";
        };

        nix-gaming = {
            url = "github:fufexan/nix-gaming";
        };

        nixgl = {
            url = "github:nix-community/nixGL";
        };

        nur = {
            url = "github:nix-community/NUR";
        };

        agenix = {
            url = "github:ryantm/agenix";
        };

        home-manager = {
            url = "github:nix-community/home-manager/";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        chaotic = {
            url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
        };

        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        sops-nix = {
            url = "github:Mic92/sops-nix";
        };

        stylix = {
            url = "github:danth/stylix";
        };
        polymc = {
            url = "github:PolyMC/PolyMC"
        };
        nixvim = {
            url = "github:nix-community/nixvim";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, chaotic, ... }@inputs:
    {
        nixosConfigurations = {
            goidapc = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix 
                    chaotic.nixosModules.default
                ];
            };
        };
    };
}
