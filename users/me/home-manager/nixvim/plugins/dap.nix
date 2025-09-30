{utils, ...}: {pkgs, ...}: let
  keymapRaw = utils.keymapRaw;
in {
  programs.nixvim = {
    plugins.dap-ui = {
      # Not working yet, save CPU for now
      enable = false;

      lazyLoad = {
        settings = {
          before.__raw = ''
            function()
              require('lz.n').trigger_load('nvim-dap')
            end
          '';
          keys = [
            "<leader>td"
          ];
        };
      };
    };

    plugins.dap = {
      # Not working yet, save CPU for now
      enable = false;

      lazyLoad = {
        settings = {
          keys = [
            "<leader>td"
          ];
        };
      };

      configurations.javascript = [
        {
          name = "Attach to process";
          type = "js-debug";
          request = "attach";
          processId = "require('dap.utils').pick_process";
        }
      ];

      adapters.servers = {
        # js-debug = {
        #   host = "localhost";
        #   port = "\${port}";
        #   executable = {
        #     command = "${pkgs.nodejs}/bin/node";
        #     args = ["${pkgs.vscode-js-debug}/src/dapDebugServer.js" "\${port}"];
        #   };
        # };
      };

      luaConfig.post = ''
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
      '';
    };

    # keymapsOnEvents = {
    #   InsertEnter = [
    #     (keymapRaw "<leader>td" "require('dapui').toggle" "Toggle DAP-UI (debugger UI)" {})
    #   ];
    # };

    extraPackages = with pkgs; [
      # vscode-js-debug
    ];
  };
}
