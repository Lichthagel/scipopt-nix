{
  pkgs ? import <nixpkgs> {},
  scip ? pkgs.callPackage ./scip.nix {},
  ...
}:
pkgs.stdenv.mkDerivation rec {
  name = "gcg";

  src = builtins.fetchGit {
    url = "git@git.or.rwth-aachen.de:gcg/gcg.git";
    ref = "master";
    rev = "d80c922b46204bb432e4c09b8291efaa3f67da74";
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

  buildPhase = ''
    runHook preBuild

    echo "#define GCG_GITHASH \"${src.rev}\"" > ../src/githash.c

    cmake --build . ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}}

    runHook postBuild
  '';
}
