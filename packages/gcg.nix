{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  scip ? pkgs.callPackage ./scip.nix {},
  debugFiles ? [], # add `#define SCIP_DEBUG` to these files (e.g. ["src/gcg/cons_decomp.cpp"])
  ...
}: let
  gcg-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .gcg;
in
  pkgs.stdenv.mkDerivation {
    inherit (gcg-src) pname version src;

    nativeBuildInputs = with pkgs; [
      cmake
      git # to obtain git commit hash
    ];

    buildInputs =
      (with pkgs; [
        bliss
        cliquer
        gmp
        gsl
      ])
      ++ [scip];

    outputs = [
      "bin"
      "dev"
      "out"
    ];

    patches = [
      ../patches/gcg_dirs.patch
    ];

    postPatch = ''
      # Add #define SCIP_DEBUG to debug files
      for file in ${builtins.concatStringsSep " " debugFiles}; do
        sed -i '1s/^/#define SCIP_DEBUG\n/' $file
      done
    '';

    enableParallelBuilding = true;
    doCheck = true;

    meta = {
      description = "Branch-and-Price & Column Generation for Everyone";
      homepage = "https://gcg.or.rwth-aachen.de/";
      license = lib.licenses.lgpl3;
    };
  }
