{
  lib,
  config,
  ...
}: {
  options = {
    vim = {
      local = {
        indenting = lib.mkOption {
          type = lib.types.listOf lib.types.submodule {
            options = {
              tabstop = lib.mkOption {
                type = lib.types.ints.positive;
              };

              shiftwidth = lib.mkOption {
                type = lib.types.ints.positive;
              };

              expandtab = lib.mkEnableOption "Expands tabs to spaces.";
            };
          };

          default = [];
        };
      };
    };
  };

  config = let
    cfg = config.vim.local;
  in {
    vim = {
      autocmds = [
        # TODO: Generate these from the options!
        # {
        #   event = ["FileType"];
        #   pattern = ["alpha"];
        #   group = "Alpha";
        #   callback = lib.generators.mkLuaInline ''
        #     function()
        #       vim.opt_local.fillchars = { eob = " " }
        #     end
        #   '';
        #   desc = "Setting end of buffer character to space.";
        # }
      ];
    };
  };
}
