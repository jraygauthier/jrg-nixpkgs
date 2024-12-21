# Install the overlay on a NixOS classic system

<!--
    cSpell:ignore MYLONGGITHASHPIN
-->

Adapt your `/etc/nixos/configuration.nix` in such a way that you retrieve a
specific (a.k.a: pinned) revision of the `jrg-nixpkgs` flake via `getFlake` and
add its `default` overlay to the `nixpkgs.overlays` attribute of your
configuration. Here's a fully functional example:

```nix
{ pkgs, ... }:
{
  # ..
  nixpkgs.overlays = [
    (builtins.getFlake "github:jraygauthier/jrg-nixpkgs?rev=MYLONGGITHASHPIN")
    .overlays.default
  ];

  environment.systemPackages = with pkgs; [
    # Replace this with the specific packages you need
    # from this flake.
    jrg-nixpkgs-hello
    # ..
  ];
  # ..
  # What follow is just to allow for this config to build.
  # Please replace by your own stuff.
  boot.loader.systemd-boot.enable = true;
  fileSystems."/" = {
    device = "/dev/sda";
  };
}
```

Please replace `MYLONGGITHASHPIN` by the specific git revision of the
`jrg-nixpkgs` flake your desire (the latest revision would be as good a choice
as any).

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
