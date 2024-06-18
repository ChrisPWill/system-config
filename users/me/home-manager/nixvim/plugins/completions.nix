{
  lib,
  config,
  ...
}: let
  cfg = config.programs.nixvim.custom;
in {
  programs.nixvim.plugins = {
    luasnip.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-document-symbol.enable = true;
    cmp = {
      enable = true;

      settings = {
        sources =
          [
            {name = "nvim_lsp";}
          ]
          ++ lib.optionals cfg.enableCopilot [{name = "copilot";}];

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
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
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
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, {'i', 's'})
          '';
        };
      };

      cmdline = {
        "/".sources = [
          {name = "nvim_lsp_document_symbol";}
          {name = "buffer";}
        ];
      };
    };
  };
}
