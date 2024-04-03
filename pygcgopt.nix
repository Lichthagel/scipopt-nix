{
  callPackage,
  buildPythonPackage,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  cython,
  pyscipopt ? callPackage ./pyscipopt.nix {},
  scip ? callPackage ./scip.nix {},
  gcg ? callPackage ./gcg.nix {},
  ...
}: let
  pygcgopt-src =
    (import ./_sources/generated.nix {
      inherit
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .pygcgopt;
in
  buildPythonPackage {
    inherit (pygcgopt-src) pname version src;

    # version =
    #   let
    #     matches = builtins.match "v(.+)" pygcgopt-src.version;
    #   in
    #   builtins.head matches;

    nativeBuildInputs = [cython];

    propagatedBuildInputs = [pyscipopt];

    enableParallelBuilding = true;

    SCIPOPTDIR = "${scip}";
    GCGOPTDIR = "${gcg}";
  }
