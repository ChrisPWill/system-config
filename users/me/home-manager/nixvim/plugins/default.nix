{...}: {
  imports = [
    ./completions.nix
    ./lsp.nix
    ./telescope.nix
    ./treesitter.nix
  ];

  programs.nixvim.plugins = {
    git-conflict.enable = true;
    fzf-lua.enable = true;
  };
}
