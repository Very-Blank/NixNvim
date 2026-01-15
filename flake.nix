{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nvf.url = "github:NotAShelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";

    colors = {
      url = "github:Very-Blank/colors";
      inputs.nixpkgs.follows = "nixpkgs";
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
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    packages = forAllSystems (system: {
      default = nixpkgs.lib.makeOverridable (
        {languages ? ["nix"], ...}:
          (inputs.nvf.lib.neovimConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};

            modules = [
              ({...}: {
                imports = [
                  ./modules
                ];

                config = {
                  nixnvim.languages = languages;
                };
              })
            ];

            extraSpecialArgs = {};
          }).neovim
      ) {};
    });
  };
}
