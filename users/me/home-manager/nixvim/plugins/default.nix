{utils, ...}: {config, ...}: let
  cfg = config.programs.nixvim.custom;
in {
  imports = [
    # Contains cmp and so on
    ./completions.nix

    # Language server config
    (import ./lsp.nix {inherit utils;})

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

  programs.nixvim.plugins = {
    # Bottom bar with statuses etc.
    airline = {
      enable = true;
      settings.powerline_fonts = true;
    };

    # Top bar with tabs etc.
    bufferline.enable = true;

    # Git tools
    fugitive.enable = true;

    # Conflict resolution plugin (co for choose ours, ct for choose theirs,
    # cb for both, c0 for none, ]x for next conflict, [x for prev conflict)
    git-conflict.enable = true;

    # Shows git changes on left side
    gitgutter.enable = true;

    # Highlights same references
    illuminate.enable = true;

    # Leap to parts of file with x and X
    leap.enable = true;

    # Notification manager
    notify.enable = true;

    # File tree on side
    nvim-tree = {
      enable = true;
      hijackCursor = true;
      modified.enable = true;
      updateFocusedFile.enable = true;
      renderer.groupEmpty = true;
      view = {
        preserveWindowProportions = true;
      };
    };

    # Add closing brackets/tags/etc.
    surround.enable = true;

    # Diagnostics/symbols/etc. at bottom \xx
    trouble.enable = true;

    copilot-lua.enable = cfg.enableCopilot;

    which-key.enable = true;
  };
}
