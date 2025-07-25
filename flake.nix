{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

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
      inherit (nixpkgs) lib;

      myLib = import ./.nix/lib/private.nix { inherit lib; };

      getOverlayPackages =
        pkgs:
        # Make sure only packages marked as compatible with `pkgs.system` end
        # up in the final set.
        myLib.filterSupportedOnSystem pkgs.system (
          with pkgs;
          {
            inherit jrg-nixpkgs-hello;
            inherit markdown-code-runner;
            inherit modbus-cli;
            inherit node-bcat;
          }
        );

      forSystems =
        systems: f:
        lib.genAttrs systems (
          system:
          f rec {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ self.overlays.default ];
            };
            overlayPackages = getOverlayPackages pkgs;
          }
        );

      forAllSystems = forSystems (
        myLib.filterStringsNotIn [
          # Since 24.11 -> 25.05 update, 'checks.x86_64-freebsd.node-bcat' fails with:
          # "Package ‘rustc-wrapper’ in is marked as broken, refusing to evaluate".
          "x86_64-freebsd"
        ] lib.systems.flakeExposed
      );
      forMaintainerSystems = forSystems (
        myLib.filterStringsNotIn [
          # Cannot bootstrap GHC on this platform:
          "armv6l-linux"
          "riscv64-linux"
          # Package ‘markdownlint-cli is not available on the requested hostPlatform:
          "x86_64-freebsd"
        ] lib.systems.flakeExposed
      );
    in
    {
      githubActions = nix-github-actions.lib.mkGithubMatrix ({
        # Github actions only support a limited set of systems.
        checks = lib.getAttrs [
          "x86_64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ] self.checks;
      });

      overlays = {
        default = import ./.nix/overlays.nix;
      };

      devShells = myLib.mergePerSystemAttrs [
        (forAllSystems (
          { pkgs, overlayPackages, ... }:
          rec {
            default = packages;

            packages = pkgs.mkShell {
              packages = builtins.attrValues overlayPackages;
            };
          }
        ))
        (forMaintainerSystems (
          { pkgs, ... }:
          {
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
        ))
      ];

      packages = forAllSystems (
        { pkgs, overlayPackages, ... }:
        overlayPackages
        // {
          default = pkgs.symlinkJoin {
            name = "flake-all-packages";
            paths = builtins.attrValues overlayPackages;
          };
        }
      );

      checks = self.packages;
    };
}
