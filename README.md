# Nix Development Container

A portable development environment using Nix on Ubuntu for container-native development.

## Features

- **Ubuntu 22.04** base image with Nix package manager
- **Declarative configuration** using nix-env with packageOverrides
- **Container-optimized packages** for development environments
- **Zero manual setup** - packages installed during container initialization
- **Dotfiles integration** - automatic setup of shell and editor configurations

## Quick Start

### DevPod (Recommended)
```bash
# Start and SSH into development environment
devpod up https://github.com/kacperlipka/devcontainers --ide none
ssh devcontainers.devpod
```

## Tools Included

- **Development**: git, gh, nodejs, claude-code
- **Editors**: neovim (LazyVim), ripgrep, fd, fzf, bat, eza
- **Shell**: starship prompt, tmux
- **Network**: curl, wget, nmap, netcat
- **Language servers**: nil (Nix), lua-language-server
- **Utilities**: jq, yq, tree

## Configuration Files

- **`.devcontainer/config.nix`**: Nix package configuration with packageOverrides
- **`.devcontainer/devcontainer.json`**: Container settings
- **`.devcontainer/setup.sh`**: Container initialization script

## Usage

This repository can be cloned into any project directory to provide a consistent, container-native development environment. The setup automatically installs all development tools and configures dotfiles for immediate productivity.

## Benefits

- **Portable**: Identical environment on any machine
- **Fast**: Pre-built packages from Nix cache
- **Declarative**: All configuration in version control
- **Isolated**: No impact on host system
- **Lightweight**: Only essential development tools included