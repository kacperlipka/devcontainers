{
  description = "Nix-based development container with remote config support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Your remote nix-config repository
    nix-config = {
      url = "github:kacperlipka/nix-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager for configuration management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nix-config, home-manager }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Create a home-manager configuration using your remote config
        homeConfiguration = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            # Import your user configuration from remote nix-config
            nix-config.inputs.nixpkgs.lib.mkDefault {
              imports = [
                "${nix-config}/users/kacperlipka.nix"
              ];

              # Override for devcontainer environment
              home = {
                username = "root";  # devcontainer default user
                homeDirectory = "/root";
                stateVersion = "24.05";
              };

              # Override git config for devcontainer
              programs.git = {
                enable = true;
                userName = "devcontainer";
                userEmail = "dev@example.com";
              };
            }
          ];
        };

        # Extract packages from your nix-config
        devcontainerPackages = with pkgs; [
          # Add any additional devcontainer-specific packages here
          devpod
        ];

      in
      {
        # Main development shell that uses your remote nix-config
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core system packages needed for devcontainer
            bash
            coreutils
            findutils
            gnugrep
            gnused
            gnutar
            gzip
            curl
            wget
            git
          ] ++ devcontainerPackages;

          shellHook = ''
            echo "╭─────────────────────────────────────────────╮"
            echo "│  Nix Development Environment (Ubuntu)       │"
            echo "│  Using remote nix-config: kacperlipka       │"
            echo "╰─────────────────────────────────────────────╯"
            echo ""
            echo "Activating home-manager environment..."

            # Activate the home-manager environment
            ${homeConfiguration.activationPackage}/activate

            # Source the generated profile
            if [ -f /root/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
              source /root/.nix-profile/etc/profile.d/hm-session-vars.sh
            fi

            echo "Your development environment is ready!"
            echo "All configurations sourced from: github:kacperlipka/nix-config"
          '';
        };

        # Alternative shell for local-only development
        devShells.local = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Minimal local setup
            bash
            git
            neovim
            tmux
            starship
          ];

          shellHook = ''
            echo "Using minimal local configuration"
          '';
        };

        # Home Manager configuration as a package
        packages = {
          homeConfiguration = homeConfiguration.activationPackage;
          default = self.devShells.${system}.default;
        };

        # Format for `nix fmt`
        formatter = pkgs.nixpkgs-fmt;
      });
}