{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  ...
}: let
  soplex-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .soplex;
in
  pkgs.stdenv.mkDerivation {
    inherit (soplex-src) pname version src;

    nativeBuildInputs = with pkgs; [
      cmake
      git
    ];

    buildInputs = with pkgs; [
      boost
      gmp
      zlib
    ];

    outputs = [
      "bin"
      "dev"
      "out"
    ];

    patches = [
      ../patches/soplex_dirs.patch
    ];

    enableParallelBuilding = true;
    doCheck = true;

    meta = {
      description = "Sequential object-oriented simPlex";
      homepage = "https://soplex.zib.de/";
      license = lib.licenses.asl20;
    };
  }
