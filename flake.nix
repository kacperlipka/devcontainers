{
  description = "Development container using nix packages and dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Your remote nix-config repository for packages
    nix-config = {
      url = "github:kacperlipka/nix-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, nix-config }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Get devcontainer packages from nix-config
        packages = import "${nix-config}/home/packages/devcontainer.nix" { inherit pkgs; };

      in
      {
        # Development shell with packages
        devShells.default = pkgs.mkShell {
          buildInputs = packages;

          shellHook = ''
            echo "Development environment ready!"
            echo "Run bootstrap.sh to setup dotfiles"
          '';
        };

        # Format for `nix fmt`
        formatter = pkgs.nixpkgs-fmt;
      });
}
