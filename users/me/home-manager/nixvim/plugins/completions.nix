{
  lib,
  config,
  ...
}: let
  cfg = config.programs.nixvim.custom;
  # Luasnip is not working yet, save CPU for now
  enableLuasnip = false;
in {
  programs.nixvim.extraConfigLuaPre = ''
    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
  '';
  programs.nixvim.plugins = {
    luasnip = {
      enable = enableLuasnip;
      lazyLoad = {
        settings = {
          event = "InsertEnter";
        };
      };
      autoLoad = false;
      settings = {
        keep_roots = true;
        link_roots = true;
        link_children = true;
        enable_autosnippets = false;
      };
      fromVscode = [{}];
      fromLua = [
        {
          lazyLoad = true;
          paths = ./snippets;
        }
      ];
    };
    friendly-snippets = {
      enable = enableLuasnip;
    };  
    cmp-nvim-lsp = {
      enable = true;
    };
    cmp-nvim-lsp-document-symbol = {
      enable = true;
      autoLoad = false;
    };

    cmp_luasnip = {
      enable = enableLuasnip;
    };
    cmp-npm.enable = true;
    cmp-path = {
      enable = true;
    };
    cmp-buffer = {
      enable = true;
      autoLoad = false;
    };

    copilot-lua = {
      enable = cfg.enableCopilot;
      lazyLoad = {
        settings = {
          event = "InsertEnter";
        };
      };
      settings = {
        panel.enabled = false;
        suggestion.enabled = false;
      };
    };
    copilot-cmp = {
      enable = cfg.enableCopilot;
      lazyLoad = {
        settings = {
          before.__raw = ''
            function()
              require('lz.n').trigger_load('copilot-cmp')
            end
          '';
          event = "InsertEnter";
        };
      };
    };

    cmp = {
      enable = true;
      lazyLoad = {
        settings = {
          event = "InsertEnter";
          after.__raw = ''
            function()
              require('lz.n').trigger_load('cmp_buffer')
              require('lz.n').trigger_load('cmp_nvim_lsp_document_symbol')
            end
          '';
        };
      };
      autoEnableSources = false;

      settings = {
        snippet.expand = lib.mkIf enableLuasnip ''
          function(args)
            require("luasnip").lsp_expand(args.body)
          end
        '';
        sources =
          [
            (lib.mkIf enableLuasnip {name = "luasnip";})
            {name = "nvim_lsp";}
            {name = "nvim_lsp_signature_help";}
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
              -- elseif require("luasnip").expand_or_jumpable() then
              --   require("luasnip").expand_or_jump()
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
              -- elseif require("luasnip").jumpable(-1) then
              --   require("luasnip").jump(-1)
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
