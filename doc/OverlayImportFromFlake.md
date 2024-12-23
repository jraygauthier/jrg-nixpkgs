# Import the overlay from a flake

Adapt your `./flake.nix` to add the `jrg-nixpkgs` input and add its `default`
overlay to the list of overlays of the `nixpkgs` instance your import. Here's a
fully functional example:

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.jrg-nixpkgs.url = "github:jraygauthier/jrg-nixpkgs";

  outputs =
    { nixpkgs, jrg-nixpkgs, ... }:
    let
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            # ..
          ]
          (
            system:
            f {
              pkgs = import nixpkgs {
                inherit system;
                overlays = [ jrg-nixpkgs.overlays.default ];
              };
            }
          );
    in
    {
      devShells = forAllSystems (
        { pkgs, ... }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Replace this with the specific packages you need
              # from this flake.
              jrg-nixpkgs-hello
              # ..
            ];
          };
        }
      );
    };
}
```

Test your changes:

```bash
$ nix develop
# ..
$ jrg-nixpkgs-hello
Hello!
```
