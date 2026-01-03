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
            "python"
            "c"
            "cpp"
          ]);
      };
    };
  };

  config = {
    vim = {
      languages = lib.mkMerge [
        (lib.genAttrs
          config.nixnvim.languages
          (
            name: {
              enable = true;
              lsp.enable = true;
              format.enable = true;
              treesitter.enable = true;
            }
          ))

        {
          nix.lsp.servers = ["nixd"];
        }
      ];
    };
  };
}
