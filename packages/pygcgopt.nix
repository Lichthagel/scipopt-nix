{
  lib ? import <nixpkgs/lib> {},
  callPackage,
  buildPythonPackage,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  cython,
  setuptools,
  ortools,
  pyscipopt ? callPackage ./pyscipopt.nix {},
  scip ? callPackage ./scip.nix {},
  gcg ? callPackage ./gcg.nix {},
  ...
}: let
  pygcgopt-src =
    (import ../_sources/generated.nix {
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

    pyproject = true;

    nativeBuildInputs = [
      cython
      setuptools
      ortools # used in tests
    ];

    propagatedBuildInputs = [pyscipopt];

    enableParallelBuilding = true;

    patches = [../patches/pygcgopt_dirs.patch];

    SCIPINCLUDEDIR = "${scip.dev}/include";
    SCIPLIBDIR = "${scip.out}/lib";
    GCGINCLUDEDIR = "${gcg.dev}/include";
    GCGLIBDIR = "${gcg.out}/lib";

    postInstall = ''
      rm -r $out/lib/python3.11/site-packages/pyscipopt
    '';

    meta = {
      description = "Python interface for the GCG Solver.";
      homepage = "https://scipopt.github.io/PyGCGOpt/";
      license = lib.licenses.mit;
    };
  }
