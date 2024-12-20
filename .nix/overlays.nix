final: prev: {
  jrg-nixpkgs-hello = final.callPackage ./pkgs/jrg-nixpkgs-hello { };
  markdown-code-runner = final.callPackage ./pkgs/markdown-code-runner { };
}
