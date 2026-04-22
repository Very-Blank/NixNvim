{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf.url = "github:NotAShelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    colors = {
      url = "github:Very-Blank/colors";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    mkPackage = {
      system,
      extraModule ? {},
    }:
      (inputs.nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        modules = [
          ({...}: {
            imports = [
              inputs.colors.nixosModules.default
              extraModule
              ./modules
            ];
          })
        ];
      }).neovim;

    packages = forAllSystems (system: {
      default = self.mkPackage {system = system;};
    });
  };
}
