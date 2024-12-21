# Install the overlay on a NixOS classic system

<!--
    cSpell:ignore nixpkgs,nixos,jraygauthier,pkgs,MYLONGGITHASHPIN
-->

Adapt your `/etc/nixos/configuration.nix`'s `nixpkgs.overlays` attribute as
follow:

```nix
{
    # ..
    nixpkgs.overlays = [ 
        (
            builtins.getFlake 
                "github:jraygauthier/jrg-nixpkgs?rev=MYLONGGITHASHPIN"
        ).overlays.default
    ];

    environment.systemPackages = with pkgs; [
        jrg-nixpkgs-hello
        # List other packages from this flake you want
        # to install here.
        # ..
    ]
    # ..
}
```

Where `MYLONGGITHASHPIN` is the git revision you want to pin to.

Rebuild and switch to your new system:

```bash
$ sudo nixos-rebuild switch
# ..
```

Test your install:

```bash
$ jrg-nixpkgs-hello
Hello!
```
