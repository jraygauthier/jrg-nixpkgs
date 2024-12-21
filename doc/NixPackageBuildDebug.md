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

## Building the package phase by phase

```bash
# Within the package's build environment.
$ mkdir build && cd build
$ out="$PWD/install" && prefix="$PWD/install"

# The build env provide a 'genericBuild' function
# whose definition you can inspect using:
$ type genericBuild
# ..
# This is the function that nix uses to build its packages.
# Note in particular the definition of the 'phase' variable
# which we unfold just below.

# Unpacking and patching the sources
$ phases="${prePhases:-} unpackPhase patchPhase" genericBuild
# ..
# This should have downloaded the package's src under the current
# directory (`build/my-package-src-dir`) and change your working
# directory to it.

# Configure
$ phases="${preConfigurePhases:-} configurePhase" genericBuild

# Build
$ phases="${preBuildPhases:-} buildPhase" genericBuild

# Checks
$ phases="checkPhase" genericBuild

# Install
$ phases="${preInstallPhases[*]:-} installPhase" genericBuild
# ..
# The package should have installed under the directory specified
# by the 'out' and/or 'prefix' variable exported above (build/install).

# Fixup
$ phases="${preFixupPhases[*]:-} fixupPhase" genericBuild

# Install checks
$ phases="installCheckPhase ${preDistPhases[*]:-}" genericBuild

# Dist
$ phases="distPhase ${postPhases[*]:-}" genericBuild
```
