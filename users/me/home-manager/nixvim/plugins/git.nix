{...}: {
  programs.nixvim.plugins = {
    # Git tools
    fugitive.enable = true;

    # Conflict resolution plugin (co for choose ours, ct for choose theirs,
    # cb for both, c0 for none, ]x for next conflict, [x for prev conflict)
    git-conflict = {
      enable = true;
      lazyLoad = {
        settings = {
          event = "DeferredUIEnter";
        };
      };
    };

    # Shows git changes on left side
    gitgutter.enable = true;

    # Git signs for status column integration
    gitsigns = {
      enable = true;
      lazyLoad = {
        settings = {
          event = "DeferredUIEnter";
        };
      };
      settings = {
        current_line_blame = true;
      };
    };
  };


  # Git fugitive keymaps
  programs.nixvim.keymaps = [
    {
      key = "<leader>fgs";
      action = "Telescope git_status";
    }
    {
      key = "<leader>gs";
      action = ":Git status";
    }
    {
      key = "<leader>gdd";
      action = ":Git diff";
    }
    {
      key = "<leader>gdh1";
      action = ":Git diff HEAD~1";
    }
    {
      key = "<leader>gdh2";
      action = ":Git diff HEAD~2";
    }
    {
      key = "<leader>gdh3";
      action = ":Git diff HEAD~3";
    }
    {
      key = "<leader>gdm";
      action = ":Git diff origin/master";
    }
    {
      key = "<leader>gf";
      action = ":Git fetch";
    }
    {
      key = "<leader>grm";
      action = ":Git rebase origin/master";
    }
    {
      key = "<leader>grim";
      action = ":Git rebase -i origin/master";
    }
    {
      key = "<leader>grc";
      action = ":Git rebase --continue";
    }
  ];
}
