{
  lib,
  config,
  ...
}: {
  options = {
    nixnvim = {
      languages = lib.mkOption {
        default = [];
        description = "Languages to be enabled.";
        type = with lib.types;
          listOf (enum [
            "nix"
            "haskell"
            "rust"
            "zig"
            "lua"
            "python"
            "assembly"
            "clang"
            "css"
          ]);
      };
    };
  };

  config = {
    vim = {
      languages = lib.mkMerge [
        (lib.genAttrs
          languages 
          (
            name: {
              enable = true;
              lsp.enable = true;
              treesitter.enable = true;
            }
          ))

        (lib.genAttrs
          ["nix" "rust" "python" "css" "lua"]
          (
            name: {
              format.enable = true;
            }
          ))

        {
          nix.lsp.servers = ["nixd"];
        }
      ];
    };
  };
}
