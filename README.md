# Nix Development Container

A portable development environment using Nix on Ubuntu that matches your macOS configuration.

## Features

- **Ubuntu 22.04** base image with Nix package manager
- **Declarative configuration** using Nix flakes with remote package source
- **Identical tools** to your macOS environment via nix-config repository
- **Container-optimized packages** for development environments
- **Zero manual setup** - packages installed via nix-env during initialization

## Quick Start

### DevPod (Recommended)
```bash
# Start and SSH into development environment
devpod up https://github.com/kacperlipka/nix-devcontainer --ide none
ssh nix-devcontainer.devpod
```

### VS Code
1. Clone repository and open in VS Code
2. Click "Reopen in Container" when prompted

### Manual Docker
```bash
git clone https://github.com/kacperlipka/nix-devcontainer.git && cd nix-devcontainer
docker build -t nix-dev . && docker run -it -v $(pwd):/workspace nix-dev
```

## Tools Included

- **Development**: git, gh, nodejs, neovim (LazyVim), ripgrep, fd, fzf, bat, eza
- **Shell**: starship prompt, tmux, htop, btop
- **Network**: curl, wget, nmap, netcat
- **Language servers**: nil (Nix), lua-language-server
- **Utilities**: jq, yq, tree, unzip, zip, neofetch, devpod

## Configuration Files

- **`flake.nix`**: Main Nix configuration importing packages from remote nix-config
- **`.devcontainer/devcontainer.json`**: VS Code container settings
- **`.devcontainer/setup.sh`**: Container initialization script

## Architecture

The environment uses Nix for package management importing from remote nix-config:
- **Remote packages**: Pulls devcontainer-specific package sets from github:kacperlipka/nix-config
- **Architecture support**: Automatically handles x86_64 and aarch64 Linux containers
- **Development shell**: Provides immediate access to all development tools
- **Consistent environment**: Matches macOS development setup exactly

The flake.nix imports packages from the remote nix-config repository, ensuring consistency across all environments.

## Benefits

- **Portable**: Identical environment on any machine
- **Consistent**: Matches macOS development setup exactly
- **Fast**: Pre-built packages from Nix cache
- **Declarative**: All configuration in version control
- **Isolated**: No impact on host system