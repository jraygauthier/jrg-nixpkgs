# Install the overlay on a NixOS flake based system

<!--
    cSpell:ignore nixpkgs,nixos,jraygauthier,pkgs
-->

Adapt your flake (e.g.: `/etc/nixos/flake.nix`, `./flake.nix`) as follow:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    jrg-nixpkgs.url = "github:jraygauthier/jrg-nixpkgs";
  };

  outputs = { self, nixpkgs, jrg-nixpkgs, ... }:
  {
      nixosConfigurations."my-host-name" = nixpkgs.lib.nixosSystem {
        system = "my-system-architecture";
        modules = [
          ({ config, pkgs, ... }: {
            # ..
            nixpkgs.overlays = [ 
                jrg-nixpkgs.overlays.default
            ]; 

            environment.systemPackages = with pkgs; [
                jrg-nixpkgs-hello
                # List other packages from this flake you want
                # to install here.
                # ..
            ]
            # ..
           })
        ];
      };
  }
}
```

Where `my-system-architecture` is your own system's architecture (e.g.:
`x86_64-linux`) and `my-host-name` is you own machine's hostname

Rebuild and switch to your new system:

```bash
# Default location system flake ('/etc/nixos/flake.nix'):
$ sudo nixos-rebuild switch
# ..
# Non default location flake (current directory):
$ sudo nixos-rebuild switch --flake '.#'
# ..
```

Test your install:

```bash
$ jrg-nixpkgs-hello
Hello!
```
