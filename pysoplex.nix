{
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  soplex ? callPackage ./soplex.nix { },
  ...
}:
buildPythonPackage {
  name = "pysoplex";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "PySoPlex";
    rev = "0def0a370ea08d1f1f34b0e5a2e03f7e5881ac9c";
    sha256 = "sha256-8/bndwQ0aUSMl3XTZctfW3SH85IIrlCln6+9cQGuU9Q=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  enableParallelBuilding = true;

  SOPLEX_DIR = "${soplex}";
}
