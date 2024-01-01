{
  pkgs,
  pyscipopt ? pkgs.callPackage ./pyscipopt.nix {},
  scip ? pkgs.callPackage ./scip.nix {},
  gcg ? pkgs.callPackage ./gcg.nix {},
  ...
}: let
  ps = pkgs.python3.pkgs;
in
  ps.buildPythonPackage rec {
    pname = "pygcgopt";
    version = "0.3.1";

    src = pkgs.fetchFromGitHub {
      owner = "scipopt";
      repo = "pygcgopt";
      rev = "v${version}";
      sha256 = "sha256-nVT1Azyp5+nL7pIB04G4mSrm4+3m8iz0wXd7FIXp0ag=";
    };

    nativeBuildInputs = with ps; [
      cython
    ];

    propagatedBuildInputs = [
      pyscipopt
    ];

    enableParallelBuilding = true;

    SCIPOPTDIR = "${scip}";
    GCGOPTDIR = "${gcg}";
  }
