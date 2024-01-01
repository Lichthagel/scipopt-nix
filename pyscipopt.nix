{
  pkgs,
  scip ? pkgs.callPackage ./scip.nix {},
  ...
}: let
  ps = pkgs.python3.pkgs;
in
  ps.buildPythonPackage rec {
    pname = "pyscipopt";
    version = "4.4.0";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "scipopt";
      repo = "PySCIPOpt";
      rev = "v${version}";
      sha256 = "sha256-xI5auBByQIA/eb/u1/8u7A0xyZHeRMw3hA+BGTFWf84=";
    };

    nativeBuildInputs = with ps; [
      cython
      setuptools
    ];

    enableParallelBuilding = true;

    SCIPOPTDIR = "${scip}";
  }
