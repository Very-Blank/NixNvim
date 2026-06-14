{lib, ...}: {
  config = {
    vim = {
      keymaps = lib.mkMerge [
        [
          {
            key = "<Esc>";
            mode = "n";
            silent = true;
            action = "<cmd>nohlsearch<CR>";
            desc = "Clear search highlights";
          }
          {
            key = "<leader>q";
            mode = "n";
            silent = true;
            action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
            desc = "Open diagnostic [Q]uickfix list";
          }
        ]
        (
          map
          (option: {
            key = "<C-${option.key}>";
            mode = "n";
            silent = true;
            action = "<C-w><C-${option.key}>";
            desc = "Move focus to the ${option.direction} window";
          })
          [
            {
              key = "h";
              direction = "left";
            }
            {
              key = "l";
              direction = "right";
            }
            {
              key = "j";
              direction = "lower";
            }
            {
              key = "k";
              direction = "upper";
            }
          ]
        )
      ];

      lsp.mappings = {
        renameSymbol = "<leader>rn";
        goToDefinition = "<leader>gd";
        goToType = "<leader>gt";
        listReferences = "<leader>lr";
        nextDiagnostic = "<leader>gnd";
        previousDiagnostic = "<leader>gpd";
      };

      autocomplete.blink-cmp = {
        mappings = {
          confirm = "<C-y>";
          previous = "<C-p>";
          next = "<C-n>";
        };
      };

      utility.motion.leap = {
        mappings = {
          leapBackwardTo = "<leader>S";
          leapForwardTo = "<leader>s";
        };
      };
    };
  };
}
