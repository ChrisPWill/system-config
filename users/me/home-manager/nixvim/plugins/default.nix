{utils, ...}: {
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.nixvim.custom;
in {
  imports = [
    # Contains cmp and so on
    ./completions.nix

    # Language server config
    (import ./lsp.nix {inherit utils;})

    # Refactoring tools
    ./refactoring.nix

    # Git-related plugins
    ./git.nix

    # Useful popup window tool
    ./telescope.nix

    # Highlighting etc.
    ./treesitter.nix

    # A group of useful utility plugins
    ./mini.nix

    # For configuring the status column on the left side
    (import ./statuscol.nix {inherit utils;})

    # Debugger adapter protocol
    (import ./dap.nix {inherit utils;})
  ];

  programs.nixvim.keymaps = [
    {
      key = "<leader>ntt";
      action = "<cmd>NvimTreeFindFile<cr>NvimTreeFocus<cr>";
      options.desc = "Toggle Nixtree";
    }
    {
      key = "<leader>ntf";
      action = "<cmd>NvimTreeFindFile<cr>";
      options.desc = "Find file in Nixtree";
    }
    {
      key = "<leader>ntr";
      action = "<cmd>NvimTreeRefresh<cr>";
      options.desc = "Refresh Nixtree";
    }
    {
      key = "<leader>ntx";
      action = "<cmd>NvimTreeClose<cr>";
      options.desc = "Close Nixtree";
    }
    {
      key = "<leader>nt[";
      action = "<cmd>NvimTreeCollapse<cr>";
      options.desc = "Collapse folders in Nixtree";
    }
  ];

  programs.nixvim.extraPlugins = with pkgs; [
    vimPlugins.plenary-nvim
  ];

  programs.nixvim.plugins = {
    # Bottom bar with statuses etc.
    # airline = {
    #   enable = true;
    #   lazyLoad = {
    #     settings = {
    #       event = "VimEnter";
    #     };
    #   };
    #   settings.powerline_fonts = 1;
    #   settings.extensions = [];
    lualine.enable = true;

    # Top bar with tabs etc.
    bufferline.enable = true;


    # Discourages bad habits, gives tips
    hardtime.enable = true;

    # Highlights same references
    illuminate.enable = true;

    # Leap to parts of file with x and X
    leap.enable = true;

    # Lazy loading
    lz-n.enable = true;
    lzn-auto-require.enable = true;

    # Notification manager
    notify.enable = true;

    # File tree on side
    nvim-tree = {
      enable = true;

      openOnSetup = false;
      lazyLoad = {
        settings = {
          event = "VimEnter";
          keys = [
            "<leader>nt"
          ];
        };
      };

      settings = {
        hijack_cursor = true;
        modified.enable = true;
        update_focused_file.enable = true;
        renderer.group_empty = true;

        view = {
          preserve_window_proportions = true;
        };

        # Replace netrw (default explorer)
        hijack_netrw = true;
        disable_netrw = true;

        hijack_unnamed_buffer_when_opening = true;
        hijack_directories.enable = true;
      };
    };

    # Add closing brackets/tags/etc.
    vim-surround.enable = true;

    # Cursor animations
    smear-cursor.enable = true;

    # Diagnostics/symbols/etc. at bottom \xx
    trouble.enable = true;

    # Helps identify which key does what
    which-key.enable = true;

    # Shows colour hex codes
    colorizer.enable = true;
  };
}
