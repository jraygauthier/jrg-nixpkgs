# Install the overlay on a NixOS flake based system

Adapt your flake (e.g.: `/etc/nixos/flake.nix`, `./flake.nix`) to add the
`jrg-nixpkgs` input and add its `default` overlay to the `nixpkgs.overlays`
attribute of the target system. Here's a fully functional example:

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.jrg-nixpkgs.url = "github:jraygauthier/jrg-nixpkgs";

  outputs =
    { nixpkgs, jrg-nixpkgs, ... }:
    {
      nixosConfigurations."my-target" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [ jrg-nixpkgs.overlays.default ];

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
          )
        ];
      };
    };
}
```

You can replace `x86_64-linux` by your own system's architecture and `my-target`
by your own machine's name / hostname.

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

Note that it is also possible to build the target machine and inspect its
content without even switching to it:

```bash
$ nix build .#nixosConfigurations.my-target.config.system.build.toplevel
# ..
$ ls ./result/sw/bin/jrg-nixpkgs-hello 
./result/sw/bin/jrg-nixpkgs-hello
$ ./result/sw/bin/jrg-nixpkgs-hello
Hello!
```
