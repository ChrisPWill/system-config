{ utils }: { pkgs, ... }:
let
  keymap = utils.keymap;
  keymapRaw = utils.keymapRaw;
in
{
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        dockerls.enable = true;
        graphql.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua-ls.enable = true;
        nil-ls.enable = true;
        nil-ls.settings.formatting.command = [ "nixpkgs-fmt" ];
        rust-analyzer.enable = true;
        tailwindcss.enable = true;
        tsserver.enable = true;
      };
    };

    extraPackages = with pkgs; [
      bash-language-server
      dockerfile-language-server-nodejs
      lua-language-server
      nil
      nixpkgs-fmt
      nodePackages.graphql-language-service-cli
      nodePackages.typescript-language-server
      rust-analyzer
      tailwindcss-language-server
      vscode-langservers-extracted
    ];


    keymaps = [
      (keymap "<A-]>" "<C-I>" "Go to newer jump" { })
      (keymap "<A-[>" "<C-O>" "Go to older jump" { })

      # LSP specific
      (keymapRaw "KK" "vim.lsp.buf.hover" "Show LSP info" { })
      (keymapRaw "KA" "vim.lsp.buf.code_action" "LSP Code Action" { })
      (keymapRaw "KE" "vim.lsp.buf.rename" "LSP Rename" { })
      (keymapRaw "KD" "vim.lsp.buf.definition" "LSP Open Definition" { })
      (keymapRaw "KI" "vim.lsp.buf.implementation" "LSP Open Implementations" { })
      (keymapRaw "KN" "vim.diagnostic.goto_next" "LSP Goto next diagnostic" { })
      (keymapRaw "KP" "vim.diagnostic.goto_prev" "LSP Goto prev diagnostic" { })
      (keymapRaw "KR" "require('telescope.builtin').lsp_references" "Show LSP References" { })
      (keymap "KT" "<cmd>Telescope diagnostics<cr>" "Show LSP Diagnostics" { })
      (keymapRaw "KF" "function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end" "LSP Format" { })
    ];
  };
}
