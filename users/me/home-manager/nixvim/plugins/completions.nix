{ lib
, config
, ...
}:
let
  cfg = config.programs.nixvim.custom;
in
{
  programs.nixvim.extraConfigLuaPre = ''
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
  '';
  programs.nixvim.plugins = {
    luasnip.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-document-symbol.enable = true;
    cmp = {
      enable = true;

      settings = {
        sources =
          [
            { name = "nvim_lsp"; }
          ]
          ++ lib.optionals cfg.enableCopilot [{ name = "copilot"; }];

        mapping = {
          "<CR>" = ''
            cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
              })
          '';
          "<C-space>" = "cmp.mapping.complete()";
          "<Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif require("luasnip").expand_or_jumpable() then
                require("luasnip").expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, {'i', 's'})
          '';
          "<S-Tab>" = ''
            cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif require("luasnip").jumpable(-1) then
                require("luasnip").jump(-1)
              else
                fallback()
              end
            end, {'i', 's'})
          '';
        };
      };

      cmdline = {
        "/".sources = [
          { name = "nvim_lsp_document_symbol"; }
          { name = "buffer"; }
        ];
      };
    };
  };
}
