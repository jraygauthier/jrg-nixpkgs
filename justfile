default: check build

build:
    @nix build .#default

check: check-flake check-format

check-ci: check-format

check-flake:
    @nix flake check --all-systems

check-format: check-format-nix

check-format-nix:
    @find -type f -name '*.nix' -exec nixfmt --check '{}' +

format: format-nix

format-nix:
    @find -type f -name '*.nix' -exec nixfmt '{}' +

shell: shell-packages

shell-packages:
    @nix develop .#packages
