# JRG nixpkgs

<!--
    cSpell:ignore nixpkgs,jraygauthier,Gauthier,nixos,distro
-->

[![CI Status][ci-badge]][ci-url]

[ci-badge]: https://github.com/jraygauthier/jrg-nixpkgs/actions/workflows/ci.yml/badge.svg
[ci-url]: https://github.com/jraygauthier/jrg-nixpkgs/actions/workflows/ci.yml

A set of [nix] packages I maintain awaiting their inclusion into upstream
[nixpkgs].

[nix]: https://nixos.org/download/
[nixpkgs]: https://github.com/NixOS/nixpkgs

## Install

You can trivially install any package this flake provides in your user profile
as follow:

```bash
$ nix profile install github:jraygauthier/jrg-nixpkgs#jrg-nixpkgs-hello

# Test the install:
$ jrg-nixpkgs-hello 
Hello!

# Revert our install:
$ nix profile remove packages.*.jrg-nixpkgs-hello
removing 'github:jraygauthier/jrg-nixpkgs#packages.x86_64-linux.jrg-nixpkgs-hello'
```

Here is how to *install* this flake's *overlay* (in order to use the packages it
provides) in various other contexts:

 -  [On a NixOS flake based system][overlay-install-on-nixos-flake-based-system]
 -  [On a NixOS classic system][overlay-install-on-nixos-classic-system]
 -  [On any Unix distribution][overlay-install-on-any-unix]

[overlay-install-on-nixos-flake-based-system]:
    doc/OverlayInstallOnNixosFlakeBasedSystem.md
[overlay-install-on-nixos-classic-system]:
    doc/OverlayInstallOnNixosClassicSystem.md
[overlay-install-on-any-unix]:
    doc/OverlayInstallOnAnyUnixDistro.md

### Dependencies {#install-deps}

The following dependencies are required in any cases:

 -  [nix][nix] with [flake support enabled][nix-flake-enable].

    Note that nix comes by default with [NixOS][nixos] but you still need to
    [enable flake support][nix-flake-enable].

[nixos]: https://nixos.org/
[nix-flake-enable]: https://nixos.wiki/wiki/Flakes#Enable_flakes_permanently_in_NixOS

## Usage

You can start using this flake's packages directly without having to install
anything (other than [nix], see [above dependencies section][install-deps] for
details):

```bash
$ nix develop github:jraygauthier/jrg-nixpkgs
# Now within this flake's default dev shell which gives
# access to all of its packages.
$ jrg-nixpkgs-hello 
Hello!
```

Here's how to *import* this flake's *overlay* (in order to use the packages it
provides) in various other contexts:

 -  [Import the overlay from a flake][overlay-import-from-flake]
 -  [Import the overlay from a classic nix module][overlay-import-from-classic-nix]

[install-deps]: #install-deps
[overlay-import-from-flake]: ./doc/OverlayImportFromFlake.md
[overlay-import-from-classic-nix]: ./doc/OverlayImportFromClassicNix.md

## Maintainers

 -  [@jraygauthier](https://github.com/jraygauthier)

## Contributing

A lot of details in [CONTRIBUTING.md](CONTRIBUTING.md).

## License

Licensed under either of

 -  [Apache-2.0](./LICENSE-APACHE)
 -  [MIT](./LICENSE-MIT) © Raymond Gauthier
