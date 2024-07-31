{
  pkgs,
  theme,
  ...
}: {
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

    languages = {
      language = [
        {
          name = "nix";
          formatter = {
            command = "alejandra";
          };
        }
      ];
    };

    settings = {
      theme = "base16";

      editor = {
        # Show rulers to help keep consistent line length
        rulers = [80 100 120];

        # Show list of open buffers if > 1
        bufferline = "multiple";

        lsp.display-messages = true;

        cursor-shape.insert = "bar";

        soft-wrap.enable = true;

        whitespace = {
          render.tab = "all";
          characters.tab = "→";
          render.tabpad = "all";
          characters.tabpad = "·";

          render.nbsp = "all";
          characters.nbsp = "⍽";
          render.nnbsp = "all";
          characters.nnbsp = "␣";

          indent-guides.render = true;
          indent-guides.skip-levels = 1;
        };
      };

      keys.normal = {
        space.K.F = ":format";
      };
    };

    themes = with theme;
    with theme.normal; {
      base16 = let
        transparent = "none";
      in {
        "ui.menu" = transparent;
        "ui.menu.selected" = {modifiers = ["reversed"];};
        "ui.linenr" = {
          fg = gray;
          bg = dimgray;
        };
        "ui.popup" = {modifiers = ["reversed"];};
        "ui.linenr.selected" = {
          fg = white;
          bg = black;
          modifiers = ["bold"];
        };
        "ui.selection" = {
          fg = black;
          bg = blue;
        };
        "ui.selection.primary" = {modifiers = ["reversed"];};
        "comment" = {fg = gray;};
        "ui.statusline" = {
          fg = white;
          bg = dimgray;
        };
        "ui.statusline.inactive" = {
          fg = dimgray;
          bg = white;
        };
        "ui.help" = {
          fg = dimgray;
          bg = white;
        };
        "ui.cursor" = {modifiers = ["reversed"];};
        "ui.virtual.ruler" = {bg = black;};
        "ui.virtual.indent-guide" = {fg = foreground;};
        "variable" = red;
        "variable.builtin" = orange;
        "constant.numeric" = orange;
        "constant" = orange;
        "attributes" = yellow;
        "type" = yellow;
        "ui.cursor.match" = {
          fg = yellow;
          modifiers = ["underlined"];
        };
        "string" = green;
        "variable.other.member" = red;
        "constant.character.escape" = cyan;
        "function" = blue;
        "constructor" = blue;
        "special" = blue;
        "keyword" = magenta;
        "label" = magenta;
        "namespace" = blue;
        "diff.plus" = green;
        "diff.delta" = yellow;
        "diff.minus" = red;
        "diagnostic" = {modifiers = ["underlined"];};
        "ui.gutter" = {bg = black;};
        "info" = blue;
        "hint" = dimgray;
        "debug" = dimgray;
        "warning" = yellow;
        "error" = red;
      };
    };
  };
}
