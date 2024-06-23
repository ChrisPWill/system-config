{pkgs, ...}: {
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      # language servers
      bash-language-server
      dockerfile-language-server-nodejs
      lua-language-server
      nil
      nodePackages.graphql-language-service-cli
      nodePackages.typescript-language-server
      rust-analyzer
      tailwindcss-language-server
      vscode-langservers-extracted

      # formatters
      prettierd
      stylua
      alejandra
    ];
  };
}
