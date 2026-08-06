{
  lib,
  # pkgs,
  config,
  ...
}: {
  imports = [
    ./keymaps
    ./dashboard
    ./languages
    ./plugins
  ];

  config = {
    vim = {
      theme = {
        enable = true;
        name = "base16";
        base16-colors = config.colors.palette;
      };

      globals.mapleader = " ";
      globals.maplocalleader = " ";

      lineNumberMode = "number";

      undoFile.enable = true;

      searchCase = "smart";

      clipboard = {
        enable = true;
        providers.wl-copy.enable = true;
        registers = "unnamedplus";
      };

      syntaxHighlighting = true;

      options = {
        mouse = "";
        updatetime = 250;
        cursorlineopt = "line";
        scrolloff = 18;

        tabstop = 4;
        shiftwidth = 4;
        expandtab = true;
      };

      augroups = [
        {
          name = "highlight-yank";
          clear = true;
        }
      ];

      autocmds = [
        {
          event = ["TextYankPost"];
          group = "highlight-yank";
          callback = lib.generators.mkLuaInline ''
            function()
              vim.hl.on_yank({ higroup = "IncSearch", timeout = 150, on_macro = true })
            end
          '';
          desc = "Highlight when yanking (copying) text";
        }
      ];

      # Plugins
      git.gitsigns.enable = true;
      binds.whichKey.enable = true;
      telescope.enable = true;
      formatter.conform-nvim.enable = true;

      autocomplete.blink-cmp = {
        enable = true;
        setupOpts.cmdline = {
          keymap.preset = "inherit";
          completion = {
            menu = {
              auto_show = true;
            };
          };
        };
      };

      notes.todo-comments.enable = true; # you can get quicklist by "tdq"

      mini.ai.enable = true;
      mini.surround.enable = true;
      mini.icons.enable = true;

      statusline.lualine = {
        enable = true;
      };

      ui.noice = {
        enable = true;
        setupOpts = {
          presets.command_palette = false;
        };
      };

      leap = {
        enable = true;
      };

      visuals.indent-blankline.enable = true;

      lsp.enable = true;
      lsp.formatOnSave = true;

      treesitter.enable = true;
      treesitter.indent.enable = true;
      treesitter.highlight.enable = true;

      languages = {
        nix = {
          enable = true;
          lsp = {
            enable = true;
            servers = ["nixd"];
          };

          treesitter.enable = true;
          format.enable = true;
        };

        markdown = {
          enable = true;
          lsp.enable = true;

          format = {
            enable = true;
            type = "rumdl";
          };

          treesitter.enable = true;

          extensions.render-markdown-nvim.enable = true;
        };
      };
    };
  };
}
