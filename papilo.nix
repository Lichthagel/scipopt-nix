{
  pkgs ? import <nixpkgs> { },
  soplex ? pkgs.callPackage ./soplex.nix { },
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "papilo";
  version = "2.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "scipopt";
    repo = "papilo";
    rev = "v${version}";
    sha256 = "sha256-X6xr7nhTj5q8QJHn4AtUZSTyVusUDv5X4Dgv0bLf0kE=";
  };

  nativeBuildInputs = with pkgs; [ cmake ];

  buildInputs = with pkgs; [
    boost
    gmp
    tbb_2020_3
    soplex
    zlib
  ];

  doCheck = true;
}
