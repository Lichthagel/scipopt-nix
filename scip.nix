{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  papilo ? pkgs.callPackage ./papilo.nix {},
  soplex ? pkgs.callPackage ./soplex.nix {},
  zimpl ? pkgs.callPackage ./zimpl.nix {},
  ipopt ? null,
  debugFiles ? [], # add `#define SCIP_DEBUG` to these files (e.g. ["src/scip/cons_linear.c"])
  ...
}: let
  scip-src =
    (import ./_sources/generated.nix {
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
        (pkgs.stdenv.mkDerivation {
          name = "tbb-cmake"; # package tbb with cmake support

          dontUnpack = true;

          installPhase = let
            system-names = {
              x86_64-linux = "Linux";
              aarch64-linux = "Linux";
              x86_64-darwin = "Darwin";
              aarch64-darwin = "Darwin";
            };
          in ''
            mkdir -p $out
            cp -r ${pkgs.tbb_2020_3.dev}/include $out
            cp -r ${pkgs.tbb_2020_3.dev}/nix-support $out

            mkdir -p $out/lib
            cp -r ${pkgs.tbb_2020_3}/lib/* $out/lib
            cp -r ${pkgs.tbb_2020_3.dev}/lib/* $out/lib

            mkdir -p $out/lib/cmake/TBB
            ${pkgs.cmake}/bin/cmake \
                    -DINSTALL_DIR=$out/lib/cmake/TBB \
                    -DSYSTEM_NAME=${system-names.${pkgs.stdenv.hostPlatform.system}} \
                    -DTBB_VERSION_FILE=${pkgs.tbb_2020_3.src}/include/tbb/tbb_stddef.h \
                    -P ${pkgs.tbb_2020_3.src}/cmake/tbb_config_installer.cmake
          '';
        })
        zlib
      ])
      ++ (lib.optional (ipopt != null) ipopt)
      ++ (lib.optional (papilo != null) papilo)
      ++ (lib.optional (zimpl != null) zimpl);

    outputs = [
      "bin"
      "dev"
      "out"
    ];

    patches = [
      ./patches/scip_dirs.patch
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
      ++ (lib.optional (ipopt == null) "-D IPOPT=OFF")
      ++ (lib.optional (papilo == null) "-D PAPILO=OFF")
      ++ (lib.optional (zimpl == null) "-D ZIMPL=OFF");
  }
