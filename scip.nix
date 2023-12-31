{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  papilo ? null,
  soplex ? pkgs.callPackage ./soplex.nix {},
  zimpl ? null,
  withIpopt ? false,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  name = "scip";

  src = pkgs.fetchFromGitHub {
    owner = "scipopt";
    repo = "scip";
    rev = "a8e51afd1e553cd78457a9b7b5e905aed1235bf5";
    sha256 = "sha256-TC8ypodeaMGv+bVYCKFMXKK1DPHqmAogdYwgBTWCNlQ=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
  ];

  buildInputs = with pkgs;
    [
      boost
      gmp
      readline
      soplex
      zlib
    ]
    ++ (lib.optional withIpopt ipopt)
    ++ (lib.optional (papilo != null) papilo)
    ++ (lib.optional (zimpl != null) zimpl);

  enableParallelBuilding = true;
  doCheck = true;

  cmakeFlags =
    (lib.optional (!withIpopt) "-DIPOPT=OFF")
    ++ (lib.optional (papilo == null) "-DPAPILO=OFF")
    ++ (lib.optional (zimpl == null) "-DZIMPL=OFF");

  preConfigure = ''
    echo "#define SCIP_GITHASH \"${src.rev}\"" > ./src/scip/githash.c
  '';
}
