#!/bin/bash
set -e

echo "Setting up Nix development environment..."

# Enter the Nix shell which provides the complete development environment
exec nix-shell /workspace/shell.nix