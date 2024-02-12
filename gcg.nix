{
  pkgs ? import <nixpkgs> {},
  scip ? pkgs.callPackage ./scip.nix {},
  scipoptsuite-src ? pkgs.callPackage ./scipoptsuite-src.nix {},
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "gcg";
  version = "3.5.5";

  src = assert scipoptsuite-src.version == "8.1.0"; "${scipoptsuite-src}/gcg"; # scipoptsuite 8.1.0 ships gcg 3.5.5

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

  # preConfigure = ''
  #   echo "#define GCG_GITHASH \"${src.shortRev}\"" > ./src/githash.c
  # '';
}
