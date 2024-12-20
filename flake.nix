{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    nix-github-actions.url = "github:nix-community/nix-github-actions";
    nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-github-actions,
      ...
    }:
    let
      allPackagesFrom =
        pkgs: with pkgs; {
          inherit jrg-nixpkgs-hello;
          inherit markdown-code-runner;
          inherit modbus-cli;
          inherit node-bcat;
        };

      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      forAllSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
          }
        );
    in
    {
      githubActions = nix-github-actions.lib.mkGithubMatrix (
        let
          # Exclude systems not supported by github actions.
          ciSystems = builtins.filter (x: !({ "aarch64-linux" = null; } ? "${x}")) systems;
        in
        {
          checks = nixpkgs.lib.getAttrs ciSystems self.checks;
        }
      );

      overlays = {
        default = import ./.nix/overlays.nix;
      };

      devShells = forAllSystems (
        { pkgs, ... }:
        rec {
          default = packages;

          packages = pkgs.mkShell {
            packages = builtins.attrValues (allPackagesFrom pkgs);
          };

          maintainer = pkgs.mkShell {
            packages = with pkgs; [
              bashInteractive
              coreutils
              fd
              just
              markdownlint-cli
              nixfmt-rfc-style
              nodePackages.cspell
            ];
          };
        }
      );

      packages = forAllSystems (
        { pkgs, ... }:
        let
          all = allPackagesFrom pkgs;
        in
        all
        // {
          default = pkgs.symlinkJoin {
            name = "flake-all-packages";
            paths = builtins.attrValues all;
          };
        }
      );

      checks = nixpkgs.lib.getAttrs systems self.packages;
    };
}
