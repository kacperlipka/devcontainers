# Nix Development Container

A portable development environment using Nix on Ubuntu that matches your macOS configuration.

## Features

- **Ubuntu 22.04** base image with Nix package manager
- **Declarative configuration** using `shell.nix`
- **Identical tools** to your macOS environment
- **Pre-configured dotfiles** for Neovim (LazyVim), tmux, starship, and bash
- **Zero manual setup** - everything configured automatically

## Tools Included

- **Development**: git, gh, nodejs, neovim (with LazyVim), ripgrep, fd, fzf, bat, eza
- **Shell**: starship prompt, tmux, htop, btop
- **Network**: curl, wget, nmap, netcat
- **Language servers**: nil (Nix), lua-language-server
- **Utilities**: jq, yq, tree, unzip, zip, neofetch, devpod

## Usage

### With DevPod (Recommended)

```bash
# Start devcontainer from this repository
devpod up https://github.com/kacperlipka/nix-devcontainer --ide none

# SSH into the development environment
ssh nix-devcontainer.devpod

# Your environment is ready with all tools configured!
```

### With VS Code

1. Clone this repository
2. Open in VS Code
3. Click "Reopen in Container" when prompted
4. VS Code will build and start the devcontainer automatically

### Manual Docker Usage

```bash
# Clone and build
git clone https://github.com/kacperlipka/nix-devcontainer.git
cd nix-devcontainer

# Build and run with Docker
docker build -t nix-dev .
docker run -it -v $(pwd):/workspace nix-dev
```

## Configuration

The environment is configured through:

- **`shell.nix`**: Main Nix configuration with all packages and dotfiles
- **`.devcontainer/devcontainer.json`**: Container settings for VS Code
- **`.devcontainer/setup.sh`**: Initialization script

All dotfiles (neovim, tmux, starship configs) are managed declaratively by Nix.

## What You Get

When you enter the container, you'll have:

- ✅ **Neovim with LazyVim** automatically configured
- ✅ **Tmux** with your preferred settings
- ✅ **Starship prompt** matching your macOS setup
- ✅ **All development tools** from your main configuration
- ✅ **Consistent environment** across any machine

## Development Workflow

```bash
# Start your devcontainer
devpod up https://github.com/kacperlipka/nix-devcontainer

# SSH in
ssh nix-devcontainer.devpod

# Start coding immediately - everything is ready!
nvim .
```

The environment automatically:
- Configures git with devcontainer defaults
- Sets up proper locale settings
- Links all dotfiles
- Initializes LazyVim on first neovim run

## Customization

To modify the environment:

1. Edit `shell.nix` to add/remove packages or change configurations
2. Rebuild the container to apply changes
3. The environment is completely reproducible

## Benefits

- **Portable**: Use the same environment on any machine
- **Consistent**: Matches your macOS development setup exactly
- **Fast**: Pre-built packages from Nix cache
- **Declarative**: All configuration in version control
- **Isolated**: No impact on host system