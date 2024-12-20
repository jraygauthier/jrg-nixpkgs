default: check build

build:
    @nix build .#default

check: check-flake check-static

check-ci: check-static

check-static: check-format check-spelling

check-flake:
    @nix flake check --all-systems

check-format: check-format-nix check-format-md

check-format-nix:
    @{{ _fd_nix_exec }} nixfmt --check '{}'

check-format-md:
    @{{ _fd_md_exec }} markdownlint '{}'

check-spelling:
    @{{ _fd_any_exec }} \
      cspell lint --no-summary --no-progress --file '{}'

format: format-nix

format-nix:
    @{{ _fd_nix_exec }} nixfmt '{}'

shell: shell-packages

shell-packages:
    @nix develop .#packages

_fd_base_cmd := (
    "fd . --hidden --exclude '\\.git'"
    + " --no-ignore-parent --no-global-ignore-file"
)
_fd_any_exec := _fd_base_cmd + " --exec-batch"
_fd_md_exec := _fd_base_cmd + " --extension md --exec-batch"
_fd_nix_exec := _fd_base_cmd + " --extension nix --exec-batch"
