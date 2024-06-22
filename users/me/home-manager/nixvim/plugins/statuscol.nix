{...}: {
  programs.nixvim.plugins.statuscol = {
    enable = true;
    settings = {
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
    };
  };

  programs.nixvim.plugins.gitsigns = {
    enable = true;
    extraOptions = {
      current_line_blame = true;
    };
  };
}
