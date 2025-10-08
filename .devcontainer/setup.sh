#!/bin/bash
set -e

# Setup Nix configuration
echo "Setting up Nix configuration..."
mkdir -p ~/.config/nixpkgs
cp /workspaces/devcontainers/.devcontainer/config.nix ~/.config/nixpkgs/config.nix

# Install packages using nix-env
echo "Installing development packages..."
nix-env -iA nixpkgs.devcontainerPackages

# Clone dotfiles and run bootstrap
echo "Setting up dotfiles..."
git clone https://github.com/kacperlipka/dotfiles.git /tmp/dotfiles
cd /tmp/dotfiles
./bootstrap.sh

echo "Development environment ready!"
echo "All packages have been installed via nix-env"