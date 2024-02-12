{
  lib ? import <nixpkgs/lib> {},
  pkgs ? import <nixpkgs> {},
  papilo ? pkgs.callPackage ./papilo.nix {},
  soplex ? pkgs.callPackage ./soplex.nix {},
  zimpl ? pkgs.callPackage ./zimpl.nix {},
  withIpopt ? false,
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "scip";
  version = "8.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "scipopt";
    repo = "scip";
    rev = "v${builtins.replaceStrings ["."] [""] version}";
    sha256 = "sha256-cunjmSpDM7jyEGiFiLM8kgXDR3cZGieRA9/wBtZWAwk=";
    leaveDotGit = true; # allows to obtain the git hash, but requires git & a full clone
  };

  nativeBuildInputs = with pkgs; [
    cmake
    git
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
}
