{
  pkgs ? import <nixpkgs> {},
  scip ? pkgs.callPackage ./scip.nix {},
}: let
  scippp-src =
    (import ./_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .scippp;
in
  pkgs.stdenv.mkDerivation {
    inherit (scippp-src) pname version src;

    nativeBuildInputs = with pkgs; [cmake];

    buildInputs = with pkgs; [
      boost
      scip
    ];

    outputs = [
      "dev"
      "out"
    ];

    enableParallelBuilding = true;
    doCheck = true;
  }
