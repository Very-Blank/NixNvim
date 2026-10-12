{lib, ...}: {
  config = {
    vim = {
      dashboard.alpha = {
        enable = true;
        theme = null;

        layout = [
          {
            type = "padding";
            val = 2;
          }

          {
            type = "text";
            val = [
              "                                                     "
              "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ "
              "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ "
              "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ "
              "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ "
              "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ "
              "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ "
              "                                                     "
              "                     [ Nixos  ]                     "
            ];

            opts = {
              position = "center";
              hl = "DiagnosticInfo";
            };
          }

          {
            type = "padding";
            val = 4;
          }

          {
            type = "group";

            opts = {
              "inherit" = {
                position = "center";
                width = 40;
                align_shortcut = "right";
                hl = "DiagnosticHint";
              };
            };

            val = [
              {
                type = "button";
                val = " | New File";

                on_press = lib.mkLuaInline ''
                  function()
                    vim.ui.input({ prompt = "New File: ", completion = "file" }, function(input)
                      if input == nil or input == "" then
                        return
                      end

                      vim.fn.writefile({}, input)

                      vim.cmd("edit " .. vim.fn.fnameescape(input))
                      vim.cmd("startinsert")
                    end)
                  end
                '';

                opts = {
                  shortcut = "[space c]";
                  cursor = 2;
                  keymap = [
                    "n"
                    "<space>c"
                    ":ene <BAR> startinsert <CR>"
                    {
                      noremap = true;
                      silent = true;
                    }
                  ];
                };
              }
              {
                type = "button";
                val = " | Quit Nvim";

                on_press = lib.generators.mkLuaInline ''
                  function()
                    vim.cmd("qa")
                  end
                '';

                opts = {
                  shortcut = "[space q]";
                  cursor = 2;

                  keymap = [
                    "n"
                    "<space>q"
                    ":qa<CR>"
                    {
                      noremap = true;
                      silent = true;
                    }
                  ];
                };
              }
            ];
          }
        ];
      };

      augroups = [
        {
          name = "Alpha";
          clear = true;
        }
      ];

      autocmds = [
        {
          event = ["FileType"];
          pattern = ["alpha"];
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
