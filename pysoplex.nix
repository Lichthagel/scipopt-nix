{
  callPackage,
  buildPythonPackage,
  fetchgit,
  fetchurl,
  fetchFromGitHub,
  dockerTools,
  cython,
  setuptools,
  soplex ? callPackage ./soplex.nix {},
  ...
}: let
  pysoplex-src =
    (import ./_sources/generated.nix {
      inherit
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .pysoplex;
in
  buildPythonPackage {
    inherit (pysoplex-src) pname version src;

    nativeBuildInputs = [
      cython
      setuptools
    ];

    enableParallelBuilding = true;

    SOPLEX_DIR = "${soplex}";
  }
