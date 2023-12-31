{pkgs ? import <nixpkgs> {}, ...}:
pkgs.stdenv.mkDerivation rec {
  name = "soplex";

  src = pkgs.fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "950b1658a52bc378ef80ea78a8e37a1fd671990d";
    sha256 = "sha256-miTgfouMk+TofHO6aJVY6op9JM5k1ekLkkGAfu3QVsM=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
  ];

  buildInputs = with pkgs; [
    boost
    gmp
    zlib
  ];

  enableParallelBuilding = true;
  doCheck = true;

  preConfigure = ''
    echo "#define SPX_GITHASH \"${src.rev}\"" > ./src/soplex/git_hash.cpp
  '';
}
