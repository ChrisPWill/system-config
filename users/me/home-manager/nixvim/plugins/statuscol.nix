{utils}: {...}: let
  keymapRaw = utils.keymapRaw;
in {
  programs.nixvim.plugins.statuscol = {
    enable = true;
    lazyLoad = {
      settings = {
        event = "DeferredUIEnter";
      };
    };
    settings = {
      setopt = true;
      ft_ignore = null;
      relculright = false;
      clickmod = "c";

      clickhandlers = {
        FoldClose = "require('statuscol.builtin').foldclose_click";
        FoldOpen = "require('statuscol.builtin').foldopen_click";
        FoldOther = "require('statuscol.builtin').foldother_click";
        Lnum = "require('statuscol.builtin').lnum_click";
        DapBreakpoint = "require('statuscol.builtin').toggle_breakpoint";
        DapBreakpointRejected = "require('statuscol.builtin').toggle_breakpoint";
        DapBreakpointCondition = "require('statuscol.builtin').toggle_breakpoint";
        gitsigns = "require('statuscol.builtin').gitsigns_click";
        "diagnostic/signs" = "require('statuscol.builtin').diagnostic_click";
      };

      segments = [
        {
          click = "v:lua.ScFa";
          text = [
            {
              __raw = "require('statuscol.builtin').foldfunc";
            }
            " "
          ];
        }
        {
          click = "v:lua.ScSa";
          text = [
            "%s"
          ];
        }
        {
          click = "v:lua.ScLa";
          condition = [
            true
            {
              __raw = "require('statuscol.builtin').not_empty";
            }
          ];
          text = [
            {
              __raw = "require('statuscol.builtin').lnumfunc";
            }
            " "
          ];
        }
      ];
    };
  };


  # Folds
  programs.nixvim.plugins.nvim-ufo = {
    enable = true;
    lazyLoad = {
      settings = {
        event = "DeferredUIEnter";
      };
    };
    settings.provider_selector = ''
      function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
      end
    '';
  };
  programs.nixvim.keymapsOnEvents = {
    InsertEnter = [
      {
        key = "zR";
        action = "require('ufo').openAllFolds";
        options.desc = "Open all folds (nvim-ufo)";
      }
      {
        key = "zM";
        action = "require('ufo').closeAllFolds";
        options.desc = "Close all folds (nvim-ufo)";
      }
    ];
  };
  programs.nixvim.opts = {
    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
  };
}
