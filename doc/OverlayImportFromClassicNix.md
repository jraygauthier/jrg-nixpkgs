# Import the overlay from a classic nix module

<!--
    cSpell:ignore MYLONGGITHASHPIN
-->

Adapt your `./shell.nix` in such a way that you retrieve a specific (a.k.a:
pinned) revision of the `jrg-nixpkgs` flake via `getFlake` and add its `default`
overlay to the list of overlays of the `nixpkgs` instance your import. Here's a
fully functional example:

```nix
{ }:
let
  pkgs = import <nixpkgs> {
    overlays = [
      (builtins.getFlake "github:jraygauthier/jrg-nixpkgs?rev=MYLONGGITHASHPIN")
      .overlays.default
    ];
  };
in
pkgs.mkShell {
  packages = with pkgs; [
    # Replace this with the specific packages you need
    # from this flake.
    jrg-nixpkgs-hello
    # ..
  ];
}
```

Please replace `MYLONGGITHASHPIN` by the specific git revision of the
`jrg-nixpkgs` flake your desire (the latest revision would be as good a choice
as any).

Test your changes:

```bash
$ nix-shell
# ..
$ jrg-nixpkgs-hello
Hello!
```

Note that is is possible to make `<nixpkgs>` resolve to a local `nixpkgs`
repository by using the `-I` option as follow:

```bash
$ nix-shell -I nixpkgs=~/path/to/my/local/nixpkgs/
# ..
```
