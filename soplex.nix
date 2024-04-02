{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "soplex";
  version = "7.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-${builtins.replaceStrings [ "." ] [ "" ] version}";
    sha256 = "sha256-gSpq6YFO/4e1pkJ+ZV8v3oYk56OUEGNd+Gqn2/H8bAA=";
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
