{utils}: {pkgs, ...}: let
  keymap = utils.keymap;
  keymapRaw = utils.keymapRaw;
in {
  programs.nixvim = {
    extraPackages = with pkgs; [
      # language servers
      bash-language-server
      dockerfile-language-server-nodejs
      lua-language-server
      nil
      # Temp removed https://github.com/NixOS/nixpkgs/issues/390063
      # nodePackages.graphql-language-service-cli
      nodePackages.typescript-language-server
      rust-analyzer
      tailwindcss-language-server
      vscode-langservers-extracted

      # formatters
      prettierd
      stylua
      alejandra
    ];

    plugins.lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        dockerls.enable = true;
        # Temp removed https://github.com/NixOS/nixpkgs/issues/390063
        # graphql.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua_ls.enable = true;
        nil_ls.enable = true;
        nil_ls.settings.formatting.command = ["alejandra"];
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        tailwindcss.enable = true;
        ts_ls = {
          enable = true;
          settings = {
            maxTsServerMemory = 8192;
          };
        };
      };
    };

    # Formatter
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = ''
          function(bufnr)
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end
            return { timeout_ms = 500, lsp_format = "fallback" }
          end
        '';
        formatters_by_ft = {
          # prettier
          javascript = [["prettierd" "prettier"]];
          javascriptreact = [["prettierd" "prettier"]];
          typescript = [["prettierd" "prettier"]];
          typescriptreact = [["prettierd" "prettier"]];
          css = [["prettierd" "prettier"]];
          html = [["prettierd" "prettier"]];
          json = [["prettierd" "prettier"]];
          yaml = [["prettierd" "prettier"]];
          markdown = [["prettierd" "prettier"]];
          graphql = [["prettierd" "prettier"]];
          "markdown.mdx" = [["prettierd" "prettier"]];

          rust = ["rustfmt"];

          nix = ["alejandra"];

          lua = ["stylua"];
        };
      };
    };

    userCommands = {
      FormatEnable = {
        bang = true;
        command.__raw = ''
          function(args)
            if args.bang then
              vim.b.disable_autoformat = false
            else
              vim.g.disable_autoformat = false
            end
          end
        '';
      };
      FormatDisable = {
        bang = true;
        command.__raw = ''
          function(args)
            if args.bang then
              vim.b.disable_autoformat = true
            else
              vim.g.disable_autoformat = true
            end
          end
        '';
      };
    };

    keymaps = [
      (keymap "<A-]>" "<C-I>" "Go to newer jump" {})
      (keymap "<A-[>" "<C-O>" "Go to older jump" {})

      # LSP specific
      (keymapRaw "KK" "vim.lsp.buf.hover" "Show LSP info" {})
      (keymapRaw "KA" "vim.lsp.buf.code_action" "LSP Code Action" {})
      (keymapRaw "KE" "vim.lsp.buf.rename" "LSP Rename" {})
      (keymapRaw "KD" "vim.lsp.buf.definition" "LSP Open Definition" {})
      (keymapRaw "KI" "vim.lsp.buf.implementation" "LSP Open Implementations" {})
      (keymapRaw "KN" "vim.diagnostic.goto_next" "LSP Goto next diagnostic" {})
      (keymapRaw "KP" "vim.diagnostic.goto_prev" "LSP Goto prev diagnostic" {})
      (keymapRaw "KR" "require('telescope.builtin').lsp_references" "Show LSP References" {})
      (keymap "KT" "<cmd>Telescope diagnostics<cr>" "Show LSP Diagnostics" {})
      (keymapRaw "KF" "function() require('conform').format({ async = true, timeout_ms = 10000 }) end" "LSP Format" {})
    ];
  };
}
