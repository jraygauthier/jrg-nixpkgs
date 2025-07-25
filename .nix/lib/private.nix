{ lib }:

rec {
  filterSupportedOnSystem =
    system: pkgsSet:
    let
      pred = (_name: pkg: isSupportedOnSystem pkg system);
    in
    lib.filterAttrs pred pkgsSet;

  isSupportedOnSystem =
    pkg: system:
    let
      metaPlatforms = (pkg.meta.platforms or lib.platforms.all);
    in
    lib.elem system metaPlatforms;

  filterStringsNotIn =
    excludeList: xs:
    let
      excludeSet = lib.genAttrs excludeList (_: null);
    in
    (builtins.filter (x: !(excludeSet ? "${x}"))) xs;

  mergePerSystemAttrs =
    attrsList:
    let
      allSystems = lib.unique (lib.concatMap (attrs: lib.attrNames attrs) attrsList);
    in
    lib.genAttrs allSystems (
      system: lib.foldl' (acc: attrs: acc // (attrs.${system} or { })) { } attrsList
    );
}
