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
            "c"
            "cpp"
            "css"
          ]);
      };
    };
  };

  config = {
    vim = let
      finalLanguages = (
        (builtins.filter (language: (language == "c") || (language == "cpp")) config.nixnvim.languages)
        ++ (
          if (builtins.length (builtins.filter (language: (language != "c") && (language != "cpp")) config.nixnvim.languages) != 0)
          then ["clang"]
          else []
        )
      );
    in {
      languages = lib.mkMerge [
        (lib.genAttrs
          finalLanguages
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
