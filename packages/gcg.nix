{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  scip ? pkgs.callPackage ./scip.nix {},
  debugFiles ? [], # add `#define SCIP_DEBUG` to these files (e.g. ["src/gcg/cons_decomp.cpp"])
  withHMetis ? false,
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

  hmetis = (
    pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "hmetis";
      version = "2.0pre1";

      src = pkgs.fetchurl {
        url = "https://or.rwth-aachen.de/hmetis/hmetis-${finalAttrs.version}.tar.gz";
        sha256 = "sha256-9HlCWaKHxuhz6vsEkT0VK8VPcTZJv/JxAGStljJCjCI=";
      };

      installPhase = let
        paths = {
          "x86_64-linux" = "Linux-x86_64";
          "i686-linux" = "Linux-i686";
        };
      in ''
        mkdir -p $out/bin
        install -Dm755 ${paths.${pkgs.system}}/hmetis${finalAttrs.version} $out/bin/hmetis
      '';

      meta = with lib; {
        description = "hMETIS is a set of programs for partitioning hypergraphs";
        homepage = "http://glaros.dtc.umn.edu/gkhome/metis/hmetis/overview";
        sourceProvenance = with sourceTypes; [binaryNativeCode];
        license = licenses.unfree;
        platforms = [
          "i686-linux"
          "x86_64-linux"
        ];
      };
    })
  );
in
  pkgs.stdenv.mkDerivation {
    inherit (gcg-src) pname src;

    version = let
      matches = builtins.match "v([0-9]+)([0-9])([0-9])" gcg-src.version;
    in
      builtins.concatStringsSep "." matches;

    nativeBuildInputs = with pkgs; [
      cmake
      git # to obtain git commit hash
    ];

    buildInputs =
      [
        pkgs.bliss
        pkgs.cliquer
        pkgs.gmp
        pkgs.gsl
        scip
      ]
      ++ (lib.optional withHMetis hmetis);

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

    cmakeFlags = lib.optional withHMetis [
      "-DHMETIS=ON"
      "-DHMETIS_EXECUTABLE=${hmetis}/bin/hmetis"
    ];

    meta = {
      description = "Branch-and-Price & Column Generation for Everyone";
      homepage = "https://gcg.or.rwth-aachen.de/";
      license = lib.licenses.lgpl3;
    };
  }
