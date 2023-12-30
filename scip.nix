{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  papilo ? null,
  soplex ? pkgs.callPackage ./soplex.nix {},
  zimpl ? null,
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
      ipopt
      readline
      soplex
      zlib
    ]
    ++ (lib.optional (papilo != null) papilo)
    ++ (lib.optional (zimpl != null) zimpl);

  enableParallelBuilding = true;
  doCheck = true;

  cmakeFlags =
    (lib.optional (papilo == null) "-DPAPILO=OFF")
    ++ (lib.optional (zimpl == null) "-DZIMPL=OFF");

  buildPhase = ''
    runHook preBuild

    echo "#define SCIP_GITHASH \"${src.rev}\"" > ../src/scip/githash.c

    cmake --build . ''${enableParallelBuilding:+-j''${NIX_BUILD_CORES}}

    runHook postBuild
  '';
}
