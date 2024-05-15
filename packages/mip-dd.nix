{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  scip ? pkgs.callPackage ./scip.nix {},
  ...
}: let
  mip-dd-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .mip-dd;
in
  pkgs.stdenv.mkDerivation {
    inherit (mip-dd-src) pname version src;

    outputs = [
      "out"
      "dev"
      # "bin"
    ];

    nativeBuildInputs = with pkgs; [cmake];

    buildInputs = with pkgs; [
      boost
      tbb_2021_11
      scip
    ];

    enableParallelBuilding = true;
    doCheck = true;

    cmakeFlags = [
      "-D TBB=ON"
      "-D SCIP_DIR=${scip.dev}"
    ];

    meta = {
      description = "Delta-Debugging of MIP-Solvers";
      homepage = "https://github.com/scipopt/MIP-DD";
      license = lib.licenses.asl20;
    };
  }
