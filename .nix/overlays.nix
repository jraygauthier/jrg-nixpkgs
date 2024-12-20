final: prev: {
  jrg-nixpkgs-hello = final.callPackage ./pkgs/jrg-nixpkgs-hello { };
  markdown-code-runner = final.callPackage ./pkgs/markdown-code-runner { };
  modbus-cli = final.callPackage ./pkgs/modbus-cli { };
  node-bcat = final.callPackage ./pkgs/node-bcat { };
}
