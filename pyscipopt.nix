{
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  scip ? callPackage ./scip.nix { },
  ...
}:
buildPythonPackage rec {
  pname = "pyscipopt";
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "PySCIPOpt";
    rev = "v${version}";
    sha256 = "sha256-xI5auBByQIA/eb/u1/8u7A0xyZHeRMw3hA+BGTFWf84=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  enableParallelBuilding = true;

  SCIPOPTDIR = "${scip}";
}
