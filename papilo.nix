{
  pkgs ? import <nixpkgs> {},
  soplex ? pkgs.callPackage ./soplex.nix {},
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "papilo";
  version = "2.1.4";

  src = pkgs.fetchFromGitHub {
    owner = "scipopt";
    repo = "papilo";
    rev = "v${version}";
    sha256 = "sha256-ALQYCdE4AN/Jpo8TP1UFbJi70Zxm+skcc3oTjMSZ9+Q=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
  ];

  buildInputs = with pkgs; [
    boost
    gmp
    tbb_2020_3
    soplex
    zlib
  ];

  doCheck = true;
}
