{...}: {
  imports = [
    ./completions.nix
    ./lsp.nix
    ./telescope.nix
    ./treesitter.nix
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
    airline = {
      enable = true;
      settings.powerline_fonts = true;
    };
    fugitive.enable = true;
    fzf-lua.enable = true;
    git-conflict.enable = true;
    gitgutter.enable = true;
    leap.enable = true;
    notify.enable = true;
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
    surround.enable = true;
    transparent.enable = true;
    trouble.enable = true;
  };
}
