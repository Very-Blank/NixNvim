{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.colors.nixosModule
    ./keymaps
    ./dashboard
    ./languages
  ];

  config = {
    vim = {
      theme = {
        enable = true;
        name = "base16";
        base16-colors = {
          base00 = config.scheme.base00;
          base01 = config.scheme.base01;
          base02 = config.scheme.base02;
          base03 = config.scheme.base03;
          base04 = config.scheme.base04;
          base05 = config.scheme.base05;
          base06 = config.scheme.base06;
          base07 = config.scheme.base07;
          base08 = config.scheme.base08;
          base09 = config.scheme.base09;
          base0A = config.scheme.base0A;
          base0B = config.scheme.base0B;
          base0C = config.scheme.base0C;
          base0D = config.scheme.base0D;
          base0E = config.scheme.base0E;
          base0F = config.scheme.base0F;
        };
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
              vim.hl.on_yank()
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

      utility.motion.leap = {
        enable = true;
        mappings = {
          leapForwardTo = "s";
          leapBackwardTo = "S";
        };
      };

      extraPlugins = {
        guess-indent = {
          package = pkgs.vimPlugins.guess-indent-nvim;
          setup = "require('guess-indent').setup {}";
        };
      };

      visuals.indent-blankline.enable = true;

      lsp.enable = true;
      lsp.formatOnSave = true;

      treesitter.enable = true;
      treesitter.indent.enable = true;
      treesitter.highlight.enable = true;
      # treesitter.textobjects.enable = true;
    };
  };
}
