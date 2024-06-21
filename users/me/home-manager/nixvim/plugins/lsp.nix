{pkgs, ...}: {
  programs.nixvim = {
    plugins.lsp = {
      enable = true;
      servers.nil-ls.enable = true;
    };

    extraPackages = with pkgs; [
      nil
    ];


    keymaps = [
      {
        key = "<A-]>";
        action = "<C-I>";
        options.desc = "Go to newer jump";
      }
      {
        key = "<A-[>";
        action = "<C-O>";
        options.desc = "Go to older jump";
      }

      # LSP specific
      {
        key = "KK";
        action = "vim.lsp.buf.hover";
        options.desc = "Show LSP info";
      }
      {
        key = "KA";
        action = "vim.lsp.buf.code_action";
        options.desc = "Code Action";
      }
      {
        key = "KE";
        action = "vim.lsp.buf.rename";
        options.desc = "Rename using LSP";
      }
      {
        key = "KD";
        action = "vim.lsp.buf.definition";
        options.desc = "Open LSP Definition";
      }
      {
        key = "KI";
        action = "vim.lsp.buf.implementation";
        options.desc = "Open LSP Implementation";
      }
      {
        key = "KN";
        action = "vim.lsp.buf.goto_next";
        options.desc = "Goto next LSP Diagnostic";
      }
      {
        key = "KP";
        action = "vim.lsp.buf.goto_prev";
        options.desc = "Goto previous LSP Diagnostic";
      }
      {
        key = "KR";
        action = "<cmd>Telescope references<cr>";
        options.desc = "Show LSP References";
      }
      {
        key = "KT";
        action = "<cmd>Telescope diagnostics<cr>";
        options.desc = "Show LSP Diagnostics";
      }
      {
        key = "KF";
        action = "function() vim.lsp.buf.format({ async = false, timeout_ms = 10000, })  end";
        options.desc = "Format";
      }
    ];
  };
}
