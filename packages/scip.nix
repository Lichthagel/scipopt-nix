{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  papilo ? pkgs.callPackage ./papilo.nix {},
  soplex ? pkgs.callPackage ./soplex.nix {},
  zimpl ? pkgs.callPackage ./zimpl.nix {},
  ipopt-mumps ? pkgs.callPackage ./ipopt-mumps.nix {},
  debugFiles ? [], # add `#define SCIP_DEBUG` to these files (e.g. ["src/scip/cons_linear.c"])
  ...
}: let
  scip-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .scip;
in
  pkgs.stdenv.mkDerivation {
    inherit (scip-src) pname src;

    version = let
      matches = builtins.match "v([0-9]+)([0-9])([0-9])" scip-src.version;
    in
      builtins.concatStringsSep "." matches;

    nativeBuildInputs = with pkgs; [
      cmake
      git
    ];

    buildInputs =
      (with pkgs; [
        blas
        boost
        criterion
        gmp
        readline
        lapack
        soplex
        zlib
      ])
      ++ (lib.optional (ipopt-mumps != null) ipopt-mumps)
      ++ (lib.optional (papilo != null) papilo)
      ++ (lib.optional (zimpl != null) zimpl);

    outputs = [
      "bin"
      "dev"
      "out"
    ];

    patches = [
      ../patches/scip_dirs.patch
    ];

    postPatch = ''
      # Add #define SCIP_DEBUG to debug files
      for file in ${builtins.concatStringsSep " " debugFiles}; do
        sed -i '1s/^/#define SCIP_DEBUG\n/' $file
      done
    '';

    enableParallelBuilding = true;
    doCheck = true;

    cmakeFlags =
      [
        "-D AUTOBUILD=off"
        "-D LAPACK=on"
      ]
      ++ (lib.optional (ipopt-mumps == null) "-D IPOPT=OFF")
      ++ (lib.optional (papilo == null) "-D PAPILO=OFF")
      ++ (lib.optional (zimpl == null) "-D ZIMPL=OFF");

    meta = {
      description = "Solving Constraint Integer Programs";
      homepage = "https://scipopt.org/";
      license = lib.licenses.asl20;
    };
  }
