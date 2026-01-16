{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf.url = "github:NotAShelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    colors = {
      url = "github:Very-Blank/colors";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];

    forAllSystems = nixpkgs.lib.genAttrs systems;
    lib = nixpkgs.lib;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = forAllSystems (system: {
      default = lib.makeOverridable (
        {languages ? ["nix"], ...}:
          (inputs.nvf.lib.neovimConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};

            modules = [
              ({...}: {
                imports = [
                  inputs.colors.nixosModules.default
                  ./modules
                ];

                config = {
                  nixnvim.languages = languages;
                };
              })
            ];

            # extraSpecialArgs = {};
          }).neovim
      ) {};
    });
  };
}
