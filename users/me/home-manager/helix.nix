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

    languages = {
      # language-server.gpt = {
      #   command = "${pkgs.helix-gpt}/bin/helix-gpt";
      #   args = ["--handler" "copilot"];
      # };
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
          # language-servers = ["typescript-language-server" "gpt"];
          language-servers = ["typescript-language-server"];
        }
        {
          name = "javascript";
          formatter = prettierFormatter;
          # language-servers = ["typescript-language-server" "gpt"];
          language-servers = ["typescript-language-server"];
        }
        {
          name = "tsx";
          formatter = prettierFormatter;
          # language-servers = ["typescript-language-server" "gpt"];
          language-servers = ["typescript-language-server"];
        }
        {
          name = "jsx";
          formatter = prettierFormatter;
          # language-servers = ["typescript-language-server" "gpt"];
          language-servers = ["typescript-language-server"];
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

      language-server.typescript-language-server = with pkgs.nodePackages; {
        command = "${typescript-language-server}/bin/typescript-language-server";
        args = ["--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"];
        config = {
          settings = {
            completions = {
              completeFunctionCalls = true;
            };
          };
        };
      };
    };

    settings = {
      theme = "base16";

      editor = {
        # Experimental, turn off if buggy
        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "error";
        };
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
        A-W = "move_next_sub_word_start";
        A-B = "move_prev_sub_word_start";
        A-E = "move_next_sub_word_end";
      };
    };

    themes = with theme;
    with theme.normal; {
      base16 = let
        transparent = "none";
        light = theme.light;
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
          bg = light.white;
          fg = black;
          modifiers = ["dim"];
        };
        "ui.cursor.match" = {
          bg = light.yellow;
          modifiers = ["underlined" "dim"];
        };
        "ui.cursor.select" = {
          bg = light.blue;
          modifiers = ["bold" "dim"];
        };
        "ui.cursor.insert" = {
          bg = light.green;
          modifiers = ["underlined" "dim"];
        };
        "ui.cursor.primary" = {
          bg = light.white;
          fg = black;
          modifiers = ["underlined"];
        };
        "ui.cursor.primary.match" = {
          bg = light.yellow;
          modifiers = ["underlined"];
        };
        "ui.cursor.primary.select" = {
          bg = light.blue;
          modifiers = ["bold"];
        };
        "ui.cursor.primary.insert" = {
          bg = light.green;
          modifiers = ["underlined"];
        };
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
