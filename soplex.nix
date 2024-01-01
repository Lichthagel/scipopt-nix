{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenv.mkDerivation rec {
  pname = "soplex";
  version = "6.0.4";

  src = pkgs.fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-${builtins.replaceStrings ["."] [""] version}";
    sha256 = "sha256-mM4uBMtZjXYtsngRlqaOdOgY/uFDu11zkn+83CwbzWc=";
    leaveDotGit = true; # allows to obtain the git hash, but requires git & a full clone
  };

  nativeBuildInputs = with pkgs; [
    cmake
    git
  ];

  buildInputs = with pkgs; [
    boost
    gmp
    zlib
  ];

  enableParallelBuilding = true;
  doCheck = true;
}
