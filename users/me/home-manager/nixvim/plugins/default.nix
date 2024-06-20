{config, ...}: let
  cfg = config.programs.nixvim.custom;
in {
  imports = [
    # Contains cmp and so on
    ./completions.nix

    # Language server config
    ./lsp.nix

    # Useful popup window tool
    ./telescope.nix

    # Highlighting etc.
    ./treesitter.nix

    # A group of useful utility plugins
    ./mini.nix
  ];

  programs.nixvim.keymaps = [
    {
      key = "<leader>ntt";
      action = "<cmd>NvimTreeFindFile<cr>NvimTreeFocus<cr>";
    }
    {
      key = "<leader>ntf";
      action = "<cmd>NvimTreeFindFile<cr>";
    }
    {
      key = "<leader>ntr";
      action = "<cmd>NvimTreeRefresh<cr>";
    }
    {
      key = "<leader>ntx";
      action = "<cmd>NvimTreeClose<cr>";
    }
    {
      key = "<leader>nt[";
      action = "<cmd>NvimTreeCollapse<cr>";
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
      disableNetrw = true;
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

    # Make background transparent
    transparent.enable = true;

    # Diagnostics/symbols/etc. at bottom \xx
    trouble.enable = true;

    copilot-lua.enable = cfg.enableCopilot;
  };
}
