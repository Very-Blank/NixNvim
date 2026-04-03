{
  lib,
  config,
  ...
}: {
  options = {
    vim = {
      local = {
        indenting = lib.mkOption {
          type = lib.types.listOf (lib.types.submodule {
            options = {
              tabstop = lib.mkOption {
                type = lib.types.ints.positive;
              };

              shiftwidth = lib.mkOption {
                type = lib.types.ints.positive;
              };

              expandtab = lib.mkEnableOption "Expands tabs to spaces.";

              pattern = lib.mkOption {
                type = lib.types.listOf lib.types.nonEmptyStr;
                example = ["nix"];
              };
            };
          });

          default = [
            {
              tabstop = 2;
              shiftwidth = 2;
              expandtab = true;
              pattern = ["nix"];
            }
          ];
        };
      };
    };
  };

  config = let
    cfg = config.vim.local;
  in {
    vim = {
      autocmds =
        map
        (option: {
          event = ["FileType"];
          pattern = option.pattern;
          callback = let
            setOption = name: "vim.opt_local.${name}= ${toString option."${name}"}";
          in
            lib.generators.mkLuaInline ''
              function()
                ${setOption "tabstop"}
                ${setOption "shiftwidth"}
                ${setOption "expandtab"}
              end
            '';
          desc = "Setting language spesific indenting.";
        })
        cfg.indenting;
    };
  };
}
