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
                    vim.ui.input({ prompt = "New file: ", completion = "file" }, function(input)
                      if input == nil or input == "" then
                        return  -- user cancelled or entered nothing
                      end

                      vim.fn.writefile({}, input)

                      vim.cmd("edit " .. vim.fn.fnameescape(input))
                      vim.cmd("startinsert")
                    end)
                  end
                '';

                opts = {
                  shortcut = "[space c]";
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
                val = "󰅚 | Quit Nvim";

                on_press = lib.generators.mkLuaInline ''
                  function()
                    vim.cmd("qa")
                  end
                '';

                opts = {
                  shortcut = "[space q]";

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
              vim.opt_local.cursorline = true
              vim.opt_local.cursorlineopt = "line"
            end
          '';
          desc = "Setting end of buffer character to space.";
        }
        {
          event = ["FileType"];
          pattern = ["alpha"];
          group = "Alpha";
          callback = lib.generators.mkLuaInline ''
            function()
              local buf = vim.api.nvim_get_current_buf()
              local ns = vim.api.nvim_create_namespace("alpha_button_hl")

              local function highlight()
                if not vim.api.nvim_buf_is_valid(buf) then
                  return
                end
                vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

                local win = vim.fn.bufwinid(buf)
                if win == -1 then
                  return
                end

                local row, col = unpack(vim.api.nvim_win_get_cursor(win))
                local line = vim.api.nvim_buf_get_lines(buf, row - 1, row, false)[1] or ""
                if col >= #line then
                  return
                end

                vim.api.nvim_buf_set_extmark(buf, ns, row - 1, col, {
                  end_col = #line,
                  hl_group = "Visual",
                })
              end

              vim.api.nvim_create_autocmd("CursorMoved", {
                group = "Alpha",
                buffer = buf,
                callback = function()
                  vim.schedule(highlight)
                end,
              })

              vim.schedule(highlight)
            end
          '';
          desc = "Setting end of buffer character to space and highlighting the hovered button.";
        }
        {
          event = ["FileType"];
          pattern = ["alpha"];
          group = "Alpha";
          callback = lib.generators.mkLuaInline ''
            function()
              local buf = vim.api.nvim_get_current_buf()
              local original = vim.o.guicursor

              local function hide()
                vim.api.nvim_set_hl(0, "AlphaHiddenCursor", { blend = 100, nocombine = true })
                vim.o.guicursor = original .. ",n-v:AlphaHiddenCursor"
              end

              local function show()
                vim.o.guicursor = original
              end

              hide()

              vim.api.nvim_create_autocmd("BufEnter", {
                group = "Alpha",
                buffer = buf,
                callback = hide,
              })

              vim.api.nvim_create_autocmd({ "BufLeave", "BufUnload" }, {
                group = "Alpha",
                buffer = buf,
                callback = show,
              })
            end
          '';
          desc = "Hiding the cursor while on the dashboard.";
        }
      ];
    };
  };
}
