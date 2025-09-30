{...}: {
  programs.nixvim.plugins = {
    telescope = {
      enable = true;

      lazyLoad = {
        settings = {
          keys = [
            "<leader>ff"
            "<leader>fr"
            "<leader>fb"
            "<leader>ft"
            "<leader>fgs"
            "<leader>fgb"
            "<leader>fgcc"
          ];
        };
      };

      extensions = {
        fzf-native.enable = true;
      };
      keymaps = {
        "<leader>ff" = "find_files";
        "<leader>fr" = "live_grep";
        "<leader>fb" = "buffers";
        "<leader>ft" = "treesitter";
        "<leader>fd" = "diagnostics";
        "<leader>fgs" = "git_status";
        "<leader>fgb" = "git_branches";
        "<leader>fgcc" = "git_commits";
      };
    };
  };
}
