{
  pkgs,
  theme,
  ...
}: {
  home.packages = with pkgs; [
    # copilot language server for helix (top level so copilot can be added)
    helix-gpt
  ];
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
      language-server.gpt = {
        command = "${pkgs.helix-gpt}/bin/helix-gpt";
        args = ["--handler" "copilot"];
      };
      language = let
        prettierFormatter = {
          command = "prettierd";
          args = ["--stdin-filename" "file.tsx"];
        };
      in [
        {
          name = "nix";
          formatter = {
            command = "alejandra";
          };
        }
        {
          name = "typescript";
          formatter = prettierFormatter;
          language-servers = ["typescript-language-server" "gpt"];
        }
        {
          name = "javascript";
          formatter = prettierFormatter;
          language-servers = ["typescript-language-server" "gpt"];
        }
        {
          name = "tsx";
          formatter = prettierFormatter;
          language-servers = ["typescript-language-server" "gpt"];
        }
        {
          name = "jsx";
          formatter = prettierFormatter;
          language-servers = ["typescript-language-server" "gpt"];
        }
        {
          name = "html";
          formatter = prettierFormatter;
        }
        {
          name = "graphql";
          formatter = prettierFormatter;
        }
        {
          name = "markdown";
          formatter = prettierFormatter;
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
          render = {
            tab = "all";
            tabpad = "all";
            nbsp = "all";
            nnbsp = "all";
          };
          characters = {
            tab = "→";
            tabpad = "·";
            nbsp = "⍽";
            nnbsp = "␣";
          };
          indent-guides = {
            render = true;
            skip-levels = 1;
          };
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
          bg = silver;
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
        "ui.cursor" = {
          bg = silver;
          fg = black;
        };
        "ui.cursor.primary" = {modifiers = ["reversed"];};
        "ui.virtual.ruler" = {bg = black;};
        "ui.virtual.indent-guide" = {fg = foreground;};
        "ui.virtual.jump-label" = {
          fg = black;
          bg = yellow;
        };
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
