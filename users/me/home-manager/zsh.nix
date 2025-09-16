{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    dotDir = "${config.home.homeDirectory}/.config/zsh";

    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.config/zsh/.zshinfo";
      share = true;

      ignoreSpace = true;
      ignoreDups = true;
      extended = true;
      expireDuplicatesFirst = true;
    };

    shellAliases = {
      home-update = "home-manager switch";

      # Disable autocorrection for these
      ln = "nocorrect ln";
      mv = "nocorrect mv";
      mkdir = "nocorrect mkdir";
      sudo = "nocorrect sudo";

      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "-- -" = "cd -";
      "-- --" = "cd -2";
      "-- ---" = "cd -3";

      # zellij
      zz = "f() { zellij attach -c ''\${1:-default} };f";
      zr = "zellij run --";
      zrf = "zellij run --floating --";
      za = "f() { zellij attach ''\${1:-default} };f";
      zl = "zellij list-sessions";
      zk = "zellij kill-session";
      zka = "zellij kill-all-sessions";
    };

    initContent = let
      zshConfigEarlyInit = lib.mkBefore (
        if pkgs.system == "x86_64-darwin"
        then ''
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
          export NIX_PATH=darwin-config=$HOME/.nixpkgs/darwin-configuration.nix:$HOME/.nix-defexpr/channels''\${NIX_PATH:+:}$NIX_PATH
          source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
        ''
        else
          ""
          + ''
            #
            # General Settings {{{
            # -----------------------------------------------------------------------------

            setopt auto_name_dirs
            setopt auto_pushd
            setopt pushd_ignore_dups
            setopt pushdminus
            setopt multios
            setopt cdablevarS
            setopt autocd
            setopt extendedglob
            setopt interactivecomments
            setopt nobeep
            setopt nocheckjobs
            setopt correct
          ''
      );
      zshConfigBeforeCompletions = lib.mkOrder 550 ''
        CACHEDIR="$HOME/.cache/zsh-cache"
        fpath+=~/.zfunc
      '';
      zshConfig = lib.mkOrder 1000 ''
        # }}}
        # Prompt Style {{{
        # -----------------------------------------------------------------------------
        # This changes PS1 dynamically depending on insert or command mode.
        #


        # Generates PS1 given background colour arguments
        # $1 = user bgcolour
        # $2 = directory bgcolour
        generate_ps1() {
            setopt PROMPT_SUBST
            PS1="%{''\${1}$fg[white]%} %(!.%S-ROOT-%s.%n) %{''\${2}''\${3}%}%{$reset_color%}%{''\${3}$fg[white]%} %0~ %{[00m%}%{$reset_color''\${4}%}%{$reset_color%} "
        }

        autoload -U colors && colors
        generate_ps1 26 196

        zle-keymap-select () {
        if [[ $TERM == "rxvt-unicode" || $TERM == "rxvt-unicode-256color" || $TERM == "xterm-256color" || $TERM == "alacritty" ]]; then
            if [ $KEYMAP = vicmd ]; then
                generate_ps1 $bg[green] $fg[green] $bg[red] $fg[red]
                () { return $__prompt_status }
                zle reset-prompt
            else
                generate_ps1 $bg[blue] $fg[blue] $bg[red] $fg[red]
                () { return $__prompt_status }
                zle reset-prompt
            fi
        fi
        }
        zle -N zle-keymap-select

        zle-line-init () {
            zle -K viins
            if [[ $TERM == "rxvt-unicode" || $TERM = "rxvt-unicode-256color" || $TERM == "xterm-256color" || $TERM == "alacritty" ]]; then
                generate_ps1 $bg[blue] $fg[blue] $bg[red] $fg[red]
                () { return $__prompt_status }
                zle reset-prompt
            fi
        }
        zle -N zle-line-init

        # }}}
        # zle widgets {{{
        # -----------------------------------------------------------------------------
        # The ZLE widges are all followed by "zle -<MODE> <NAME>" and bound below in the "Key Bindings" section.

        # Delete all characters between a pair of characters. Mimics Vim's "di" text
        # object functionality.
        delete-in() {
            # Create locally-scoped variables we'll need
            local CHAR LCHAR RCHAR LSEARCH RSEARCH COUNT
            # Read the character to indicate which text object we're deleting.
            read -k CHAR
            if [ "$CHAR" = "w" ]
                then # diw, delete the word.
                # find the beginning of the word under the cursor
                zle vi-backward-word
                # set the left side of the delete region at this point
                LSEARCH=$CURSOR
                # find the end of the word under the cursor
                zle vi-forward-word
                # set the right side of the delete region at this point
                RSEARCH=$CURSOR
                # Set the BUFFER to everything except the word we are removing.
                RBUFFER="$BUFFER[$RSEARCH+1,''\${#BUFFER}]"
                LBUFFER="$LBUFFER[1,$LSEARCH]"
                return
            # diw was unique. For everything else, we just have to define the
            # characters to the left and right of the cursor to be removed
            elif [ "$CHAR" = "(" ] || [ "$CHAR" = ")" ] || [ "$CHAR" = "b" ]
            then # di), delete inside of a pair of parenthesis
                LCHAR="("
                RCHAR=")"
            elif [ "$CHAR" = "[" ] || [ "$CHAR" = "]" ]
            then # di], delete inside of a pair of square brackets
                LCHAR="["
                RCHAR="]"
            elif [ $CHAR = "{" ] || [ $CHAR = "}" ] || [ "$CHAR" = "B" ]
            then # di], delete inside of a pair of braces
                LCHAR="{"
                RCHAR="}"
            else
                # The character entered does not have a special definition.
                # Simply find the first instance to the left and right of the
                # cursor.
                LCHAR="$CHAR"
                RCHAR="$CHAR"
            fi
            # Find the first instance of LCHAR to the left of the cursor and the
            # first instance of RCHAR to the right of the cursor, and remove
            # everything in between.
            # Begin the search for the left-sided character directly the left of the cursor.
            LSEARCH=''\${#LBUFFER}
            # Keep going left until we find the character or hit the beginning of the buffer.
            while [ "$LSEARCH" -gt 0 ] && [ "$LBUFFER[$LSEARCH]" != "$LCHAR" ]
            do
                LSEARCH=$(expr $LSEARCH - 1)
            done
            # If we hit the beginning of the command line without finding the character, abort.
            if [ "$LBUFFER[$LSEARCH]" != "$LCHAR" ]
            then
                return
            fi
            # start the search directly to the right of the cursor
            RSEARCH=0
            # Keep going right until we find the character or hit the end of the buffer.
            while [ "$RSEARCH" -lt $(expr ''\${#RBUFFER} + 1 ) ] && [ "$RBUFFER[$RSEARCH]" != "$RCHAR" ]
            do
                RSEARCH=$(expr $RSEARCH + 1)
            done
            # If we hit the end of the command line without finding the character, abort.
            if [ "$RBUFFER[$RSEARCH]" != "$RCHAR" ]
            then
                return
        fi
        # Set the BUFFER to everything except the text we are removing.
            RBUFFER="$RBUFFER[$RSEARCH,''\${#RBUFFER}]"
            LBUFFER="$LBUFFER[1,$LSEARCH]"
        }
        zle -N delete-in


        # Delete all characters between a pair of characters and then go to insert mode.
        # Mimics Vim's "ci" text object functionality.
        change-in() {
            zle delete-in
            zle vi-insert
        }
        zle -N change-in

        # Delete all characters between a pair of characters as well as the surrounding
        # characters themselves. Mimics Vim's "da" text object functionality.
        delete-around() {
            zle delete-in
            zle vi-backward-char
            zle vi-delete-char
            zle vi-delete-char
        }
        zle -N delete-around

        # Delete all characters between a pair of characters as well as the surrounding
        # characters themselves and then go into insert mode Mimics Vim's "ca" text
        # object functionality.
        change-around() {
            zle delete-in
            zle vi-backward-char
            zle vi-delete-char
            zle vi-delete-char
            zle vi-insert
        }
        zle -N change-around

        # Zsh's vi-up/down-line-or-history does what I want but leaves the cursor at the
        # beginning rather than front. Perplexing!
        vim-up-line-or-history() {
            zle vi-up-line-or-history
            zle vi-end-of-line
        }
        zle -N vim-up-line-or-history
        vim-down-line-or-history() {
            zle vi-down-line-or-history
            zle vi-end-of-line
        }
        zle -N vim-down-line-or-history

        # The hackneyed <Nop> bind.
        nop() {}
        zle -N nop

        # Use clipboard rather than system registers.
        prepend-x-selection () {
            RBUFFER=$(xsel -op </dev/null)$RBUFFER;
            zle vi-end-of-line
        }
        zle -N prepend-x-selection
        append-x-selection () {
            zle vi-forward-char
            RBUFFER=$(xsel -op </dev/null)$RBUFFER;
            zle vi-end-of-line
        }
        zle -N append-x-selection
        yank-x-selection () {
            print -rn -- $CUTBUFFER | xsel -ip;
        }
        zle -N yank-x-selection
        autoload edit-command-line
        zle -N edit-command-line

        # }}}
        # The Vim setup {{{
        # -----------------------------------------------------------------------------

        bindkey -v

        # Disable flow control. Specifically, ensure that ctrl-s does not stop
        # terminal flow so that it can be used in other programs (such as Vim).
        setopt noflowcontrol
        stty -ixon

        # Disable use of ^D.
        stty eof undef

        # 1 sec <Esc> time delay? zsh pls.
        # Set to 10ms for key sequences. (Note "bindkey -rp '^['" removes the
        # availability of any '^[...' mappings, so use this instead.)
        KEYTIMEOUT=1

        ###############################################################################
        # Insert mode
        ###############################################################################

        bindkey -M viins "^?" backward-delete-char      # i_Backspace
        bindkey -M viins '^[[3~' delete-char            # i_Delete
        bindkey -M viins '^[[Z' reverse-menu-complete   # i_SHIFT-Tab

        # Non-Vim default mappings I use everywhere.
        bindkey -M viins "^N" vim-down-line-or-history  # i_CTRL-N
        bindkey -M viins "^E" vim-up-line-or-history    # i_CTRL-E
        bindkey -M viins '^V' append-x-selection        # i_CTRL-V

        # Vim defaults
        bindkey -M viins "^A" beginning-of-line         # i_CTRL-A
        bindkey -M viins "^E" end-of-line               # i_CTRL-E
        bindkey -M viins "^K" down-line-or-history      # i_CTRL-N
        bindkey -M viins "^P" up-line-or-history        # i_CTRL-P
        bindkey -M viins "^H" backward-delete-char      # i_CTRL-H
        bindkey -M viins "^B" _history-complete-newer   # i_CTRL-B
        bindkey -M viins "^F" _history-complete-older   # i_CTRL-F
        bindkey -M viins "^U" backward-kill-line        # i_CTRL-U
        bindkey -M viins "^W" backward-kill-word        # i_CTRL-W
        bindkey -M viins "^[[7~" vi-beginning-of-line   # i_Home
        bindkey -M viins "^[[8~" vi-end-of-line         # i_End

        # Edit current line in veritable Vim.
        bindkey -M viins "^H" edit-command-line         # i_CTRL-I

        # set up for insert mode too
        bindkey -M viins '^R' history-incremental-pattern-search-backward
        bindkey -M viins '^F' history-incremental-pattern-search-forward

        ###############################################################################
        # Normal mode
        ###############################################################################

        bindkey -M vicmd "ca" change-around             # ca
        bindkey -M vicmd "ci" change-in                 # ci
        bindkey -M vicmd "cc" vi-change-whole-line      # cc
        bindkey -M vicmd "da" delete-around             # da
        bindkey -M vicmd "di" delete-in                 # di
        bindkey -M vicmd "dd" kill-whole-line           # dd
        bindkey -M vicmd "gg" beginning-of-buffer-or-history # gg
        bindkey -M vicmd "G" end-of-buffer-or-history   # G
        bindkey -M vicmd "^R" redo                      # CTRL-R

        # Non-Vim default mappings I use everywhere.
        bindkey -M vicmd 'p' append-x-selection         # p
        bindkey -M vicmd 'P' prepend-x-selection        # P
        bindkey -M vicmd 'y' yank-x-selection           # y
        #bindkey -M vicmd 'Y' yank-to-end-x-selection    # Y
        bindkey -M vicmd "z" vi-substitute              # z

        # Vim defaults I don't use but I may as well keep.
        bindkey -M vicmd "^H" vi-add-eol                # CTRL-E
        bindkey -M vicmd "g~" vi-oper-swap-case         # g~
        bindkey -M vicmd "ga" what-cursor-position      # ga

        # Search backwards and forwards with a pattern
        bindkey -M vicmd '/' history-incremental-pattern-search-backward
        bindkey -M vicmd '?' history-incremental-pattern-search-forward

        if [ -n "''\${commands[fzf-share]}" ]; then
          source "''\$(fzf-share)/key-bindings.zsh"
          source "''\$(fzf-share)/completion.zsh"
        fi

        # nvm
        lazy_load_nvm() {
          unset -f node nvm
          export NVM_DIR=~/.nvm
          [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
        }

        node() {
          lazy_load_nvm
          node $@
        }

        nvm() {
          lazy_load_nvm
          node $@
        }

        function vimdifffiles() {
            local commit_range="$1" # Capture the commit range argument

            # Check if commit range is provided
            if [[ -z "$commit_range" ]]; then
                echo "Please specify a commit range. For example: vimdifffiles HEAD~2..HEAD~1"
                return 1
            fi

            # Get a list of modified files in the commit range
            local files=($(git diff --name-only $commit_range))

            # Check if there are any modified files
            if [[ ''\${#files[@]} -eq 0 ]]; then
                echo "No modified files found in the specified commit range."
                return 1
            fi

            # Open the modified files in neovim
            nvim -p "''\${files[@]}"
        }
      '';
    in
      lib.mkMerge [
        zshConfigEarlyInit
        zshConfigBeforeCompletions
        zshConfig
      ];

    completionInit = ''
      autoload -Uz compinit
      if [[ -n ''\${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
        compinit -d $CACHEDIR/zcompdump 2>/dev/null
      else
      	compinit -C;
      fi;

      # (z/autojump like cd command)
      eval "$(zoxide init zsh)"

      # Use cache to speed completion up and set cache folder path.
      zstyle ':completion:*' use-cache on
      zstyle ':completion:*' cache-path $CACHEDIR

      # Auto-insert first suggestion.
      setopt menu_complete

      # If the <tab> key is pressed with multiple possible options, print the
      # options. If the options are printed, begin cycling through them.
      zstyle ':completion:*' menu select

      # Set format for warnings.
      zstyle ':completion:*:warnings' format 'Sorry, no matches for: %d%b'

      # Use colors when outputting file names for completion options.
      zstyle ':completion:*' list-colors ''\''

      # Do not prompt to cd into current directory.
      # For example, cd ../<tab> should not prompt current directory.
      zstyle ':completion:*:cd:*' ignore-parents parent pwd

      # Completion for kill.
      zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
      zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,cputime,cmd'

      # Show completion for hidden files also.
      zstyle ':completion:*' file-patterns '*(D)'

      # Red dots!
      expand-or-complete-with-dots() {
          echo -n "\e[31m......\e[0m"
          zle expand-or-complete
          zle redisplay
      }
      zle -N expand-or-complete-with-dots
      bindkey "^I" expand-or-complete-with-dots
    '';

    profileExtra =
      ''
        # Rust
        export PATH="$HOME/.cargo/bin:$PATH"

        # pipx and other home local
        export PATH="$HOME/.local/bin:$PATH"

        # Global NPM packages
        export PATH="$HOME/.npm-packages/bin:$PATH"

        VISUAL='hx'
      ''
      + (
        if pkgs.system == "aarch64-darwin"
        then "eval \"$(/opt/homebrew/bin/brew shellenv)\""
        else ""
      );
  };
}
