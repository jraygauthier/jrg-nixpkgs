{ lib, writeShellScriptBin }:
(writeShellScriptBin "jrg-nixpkgs-hello" ''
  echo "Hello!"
'').overrideAttrs
  (old: {
    meta = with lib; {
      description = "A hello script shipped by the jrg-nixpkgs flake";
      homepage = "https://github.com/jraygauthier/jrg-nixpkgs";
      license = licenses.mit;
      maintainers = with maintainers; [ jraygauthier ];
    };
  })
