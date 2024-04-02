{
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  pyscipopt ? callPackage ./pyscipopt.nix { },
  scip ? callPackage ./scip.nix { },
  gcg ? callPackage ./gcg.nix { },
  ...
}:
buildPythonPackage rec {
  pname = "pygcgopt";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "pygcgopt";
    rev = "v${version}";
    sha256 = "sha256-nVT1Azyp5+nL7pIB04G4mSrm4+3m8iz0wXd7FIXp0ag=";
  };

  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [ pyscipopt ];

  enableParallelBuilding = true;

  SCIPOPTDIR = "${scip}";
  GCGOPTDIR = "${gcg}";
}
