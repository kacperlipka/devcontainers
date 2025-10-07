{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let
  # Neovim configuration with LazyVim
  neovimConfig = pkgs.neovim.override {
    configure = {
      customRC = ''
        " LazyVim configuration will be bootstrapped
        lua << EOF
        -- Bootstrap lazy.nvim
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
          vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
          })
        end
        vim.opt.rtp:prepend(lazypath)

        -- LazyVim setup
        require("lazy").setup({
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            { import = "plugins" },
          },
          defaults = {
            lazy = false,
            version = false,
          },
          install = { colorscheme = { "tokyonight", "habamax" } },
          checker = { enabled = true },
          performance = {
            rtp = {
              disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
              },
            },
          },
        })
        EOF
      '';
    };
  };

  # Starship configuration
  starshipConfig = pkgs.writeText "starship.toml" ''
    format = """
    $username$hostname$directory$git_branch$git_status$cmd_duration$line_break$character"""

    [username]
    show_always = true
    format = "[$user]($style) "

    [hostname]
    ssh_only = false
    format = "on [$hostname]($style) "

    [directory]
    truncation_length = 3
    format = "in [$path]($style) "

    [git_branch]
    format = "[$symbol$branch]($style) "

    [git_status]
    format = "([$all_status$ahead_behind]($style)) "

    [character]
    success_symbol = "[➜](bold green)"
    error_symbol = "[➜](bold red)"
  '';

  # Tmux configuration
  tmuxConfig = pkgs.writeText "tmux.conf" ''
    # Set prefix to Ctrl-a
    unbind C-b
    set-option -g prefix C-a
    bind-key C-a send-prefix

    # Split panes using | and -
    bind | split-window -h
    bind - split-window -v
    unbind '"'
    unbind %

    # Enable mouse mode
    set -g mouse on

    # Start windows and panes at 1
    set -g base-index 1
    setw -g pane-base-index 1

    # Reload config file
    bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

    # Status bar
    set -g status-bg colour234
    set -g status-fg colour137
    set -g status-interval 2
  '';

  # Bash configuration
  bashConfig = pkgs.writeText "bashrc" ''
    # Locale settings
    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LC_MESSAGES=en_US.UTF-8
    export LC_CTYPE=en_US.UTF-8
    export LC_COLLATE=en_US.UTF-8
    export LC_MONETARY=en_US.UTF-8
    export LC_NUMERIC=en_US.UTF-8
    export LC_TIME=en_US.UTF-8
    export LANGUAGE=en_US:en

    # Shell aliases (matching your macOS config)
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias nix-rebuild='echo "This is a devcontainer - use nix-shell to rebuild environment"'
    alias nix-update='nix flake update'

    # Initialize starship prompt
    if command -v starship &> /dev/null; then
        eval "$(starship init bash)"
    fi

    # Git configuration for devcontainer
    git config --global user.name "devcontainer" 2>/dev/null || true
    git config --global user.email "dev@example.com" 2>/dev/null || true
  '';

in pkgs.mkShell {
  buildInputs = with pkgs; [
    # Core utilities
    curl
    wget
    unzip
    zip
    tree
    htop
    btop

    # Development tools (matching your macOS environment)
    git
    gh
    jq
    yq
    nodejs_24
    devpod

    # Text editors and tools
    ripgrep
    fd
    fzf
    bat
    eza
    neovimConfig

    # Network tools
    nmap
    netcat

    # System monitoring
    neofetch

    # Language servers for Neovim
    nil
    lua-language-server

    # Shell enhancements
    starship
    tmux
  ];

  shellHook = ''
    # Create config directories
    mkdir -p $HOME/.config/starship
    mkdir -p $HOME/.config/nvim
    mkdir -p $HOME/.config/tmux

    # Link declarative configurations
    ln -sf ${starshipConfig} $HOME/.config/starship.toml
    ln -sf ${tmuxConfig} $HOME/.tmux.conf

    # Source bash configuration
    source ${bashConfig}

    echo "╭─────────────────────────────────────────────╮"
    echo "│  Nix Development Environment (Ubuntu)       │"
    echo "│  Matching your macOS configuration          │"
    echo "╰─────────────────────────────────────────────╯"
    echo ""
    echo "Available tools:"
    echo "  • neovim (with LazyVim)"
    echo "  • tmux (configured)"
    echo "  • starship (prompt)"
    echo "  • All development tools from your macOS setup"
    echo ""
    echo "Your development environment is ready!"
  '';
}