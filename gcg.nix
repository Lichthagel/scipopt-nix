{
  pkgs ? import <nixpkgs> {},
  scip ? pkgs.callPackage ./scip.nix {},
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "gcg";
  version = "3.5.5";

  src = builtins.fetchGit {
    url = "git@git.or.rwth-aachen.de:gcg/gcg.git";
    ref = "v${builtins.replaceStrings ["."] [""] version}";
    rev = "da78996a24894c343b21d3abbefe5f1251156b39";
  };

  nativeBuildInputs = with pkgs; [
    cmake
  ];

  buildInputs =
    (with pkgs; [
      cliquer
      gmp
      gsl
    ])
    ++ [scip];

  enableParallelBuilding = true;
  doCheck = true;

  cmakeFlags = [
    "-DSYM=none"
  ];

  preConfigure = ''
    echo "#define GCG_GITHASH \"${src.shortRev}\"" > ./src/githash.c
  '';
}
