# How to debugging the build of a nix package

## Entering the package's build environment

```bash
$ nix develop .#jrg-nixpkgs-hello
# ..
# Now within the build env of our package.
# All of the package's dependencies are available.

$ printenv
# ..
# The package's build environment.
```

Note that it is also possible to get a pure build environment by specifying
`--ignore-environment`.

## Building the package by running all phases at onces

```bash
# Within the package's build environment.
$ mkdir build && cd build
$ out="$PWD/install" && prefix="$PWD/install"
$ unset phases
$ genericBuild
# ..
# The package should have installed under the directory specified
# by the 'out' and/or 'prefix' variable exported above (build/install).
$ ls "$out"
# ..
```

Note that it is possible to inspect the implementation of the `genericBuild`
function as follow:

```bash
$ type genericBuild
# ..
```

This is the function that nix uses to build its packages.

## Building the package phase by phase

```bash
# Within the package's build environment.
$ mkdir build && cd build
$ out="$PWD/install" && prefix="$PWD/install"

$ runPhase unpackPhase
# ..
# This should have downloaded the package's src under the current
# directory (`build/my-package-src-dir`) and change your working
# directory to it.

$ runPhase patchPhase
# ..

$ runPhase configurePhase
# ..

$ runPhase buildPhase
# ..

$ runPhase checkPhase
# ..

$ runPhase installPhase
# ..
# The package should have installed under the directory specified
# by the 'out' and/or 'prefix' variable exported above (build/install).

$ runPhase fixupPhase
# ..

$ runPhase installCheckPhase
# ..

$ runPhase distPhase
# ..
```
