# Contributing

## Entering the reproducible environment

```bash
$ nix develop .#maintainer
# ..
```

This requires that you install [nix][nix] and [enable flake
support][nix-flake-enable].

Optionally, you can install [direnv][direnv] to make the above easier.

Any further command is assumed to be run within this reproducible environment.

[nix]: https://nixos.org/download/
[direnv]: https://direnv.net/#getting-started
[nix-flake-enable]: https://nixos.wiki/wiki/Flakes#Enable_flakes_permanently_in_NixOS

## Validating your changes

Prior to committing anything, the following checks must succeed:

```bash
$ just check
# ..
```

In case you get a formatting error, you can remedy to that through:

```bash
$ just format
# ..
```

In order to inspect the provided packages, you can:

```bash
$ just build
# ..
```

All packages' files will have been combined under the `./result` symlink:

```bash
$ ls ./result
bin  lib  nix-support
```

It is also possible to build specific package as follow:

```bash
$ nix build .#jrg-nixpkgs-hello
# -> `result`
```

Try any of the provided packages:

```bash
$ just shell
# ..

# Now within our flake's `default` shell
$ jrg-nixpkgs-hello
Hello!
```

In case something goes wrong with the build of a specific package, see [how to
debug the build of a nix package][nix-pkg-build-dbg].

[nix-pkg-build-dbg]: ./doc/NixPackageBuildDebug.md

## Committing

We use [conventional-commits]. Please make sure that you review this
repository's git history to get an idea of the expected commit message
structure.

We consider the flake's *overlay* as the *public interface* we expose to our
clients. This has a significant impact on our use of *conventional commit*, in
particular in our choice of *commit type*

Here's some guidelines to pick the proper *commit type*:

 -  `feat`:

     -  Any new package, `MAJOR` or `MINOR` package update or package removal.

        Those kind of change effectively add, alter or remove a feature to our
        publicly exposed interface (the overlay).

        Note that removing or downgrading a package would be considered a
        *breaking change*. Because of that, you must add the `BREAKING CHANGE`
        footer and the `!` type suffix (e.g.: `feat(flake)!: my summary`).

 -  `fix`:

     -  Any `PATCH` package update will be considered a `fix`.

 -  `refactor`:

     -  Structural changes made to the flake or companion nix files that are not
        observable by external users (or add any value for them).

 -  `build`:

     -  Update to `nixpkgs` (or its pin).

        This is because the end user will apply the overlay to a completely
        different `nixpkgs` over which we have no control. The version of
        nixpkgs we use here only support our build and checks.

     -  Changes to the `devShells`.

        Those only come as a support to the `justfile` we internally use for
        maintenance purpose.

     -  Changes to other non nix files such as `justfile`, `.gitignore`, etc.

 -  `docs`:

     -  Change to flake, per package meta information or comments.

     -  Changes to other non nix files such as this repository's `*.md` and
        license files.

[conventional-commits]: https://www.conventionalcommits.org
