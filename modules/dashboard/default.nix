{ lib, ... }:
{
  config = {
    vim = {
      dashboard.alpha = {
        enable = true;
        theme = "dashboard";
      };

      luaConfigRC = {
        alpha = ''
          local alpha = require("alpha")
          local dashboard = require("alpha.themes.dashboard")

          dashboard.section.header.val = {
            "                                                     ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
            "                                                     ",
            "                     [ Nixos  ]                     ",
          }

          dashboard.section.buttons.val = {
              dashboard.button("SPC c", "  New File" , ":ene <BAR> startinsert <CR>"),
              dashboard.button("SPC q", "󰅚  Quit Neovim" , ":qa<CR>"),
          }

          alpha.setup(dashboard.opts)
        '';
      };

      augroups = [
        {
          name = "Alpha";
          clear = true;
        }
      ];

      autocmds = [
        {
          event = [ "FileType" ];
          pattern = [ "alpha" ];
          group = "Alpha";
          callback = lib.generators.mkLuaInline ''
            function()
              vim.opt_local.fillchars = { eob = " " }
            end
          '';
          desc = "Setting end of buffer character to space.";
        }
      ];
    };
  };
}
