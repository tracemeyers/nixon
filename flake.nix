{
  description = "Wimpy's NixOS and Home Manager Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs at the
    # same time. See 'unstable-packages' overlay in 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # FUTURE: agenix, nix-formatter-pack, home-manager
  };
  outputs =
    { self
    , nixpkgs
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      stateVersion = "23.05";

      # Pulled this from wimpy's libx to here
      mkHost = { hostname, username, desktop ? null, installer ? null }: inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs desktop hostname username stateVersion;
        };
        modules = [
          ./nixos
          #inputs.agenix.nixosModules.default
        ] ++ (inputs.nixpkgs.lib.optionals (installer != null) [ installer ]);
      };

      forAllSystems = inputs.nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
    in
    {
      nixosConfigurations = {
        # Workstations
        #  - sudo nixos-rebuild switch --flake $HOME/Zero/nix-config
        #  - nix build .#nixosConfigurations.ripper.config.system.build.toplevel
        yogadwarf = mkHost { hostname = "yogadwarf"; username = "cat"; desktop = "plasma"; };
        minproof = mkHost { hostname = "minproof"; username = "cat"; };
        proof = mkHost { hostname = "proof"; username = "cat"; desktop = "hyprland"; };
      };

      # Custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      # FUTURE:
      # - Custom packages; acessible via 'nix build', 'nix shell', etc
    };
}
