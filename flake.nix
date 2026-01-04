{
  inputs = {
    # FIXME: https://github.com/NotAShelf/nvf/issues/1312
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/cad22e7d996aea55ecab064e84834289143e44a0";

    nvf.url = "github:NotAShelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
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
        {
          languages ? ["nix"],
          theme ? "catppuccin", # Name of the theme or base16 colors.
          style ? "macchiato",
          ...
        }:
          (inputs.nvf.lib.neovimConfiguration {
            pkgs = nixpkgs.legacyPackages.${system};

            modules = [
              ({...}: {
                imports = [./modules];
                config = let
                  isBase16 = (builtins.typeOf theme) != "string";
                in {
                  vim.theme =
                    if isBase16
                    then {
                      enable = true;
                      name = "base16";
                      base16-colors = theme;
                    }
                    else {
                      enable = true;
                      name = theme;
                      style = style;
                    };

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
