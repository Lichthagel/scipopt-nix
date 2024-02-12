{
  pkgs ? import <nixpkgs> {},
  scipoptsuite-src ? pkgs.callPackage ./scipoptsuite-src.nix {},
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "zimpl";
  version = "3.5.3";

  # Not publicly available apart from the SCIP Optimization Suite
  src = assert scipoptsuite-src.version == "8.1.0"; "${scipoptsuite-src}/zimpl"; # scipoptsuite 8.1.0 ships zimpl 3.5.3

  nativeBuildInputs = with pkgs; [
    cmake
    bison
    flex
  ];

  buildInputs = with pkgs; [
    gmp
    zlib
  ];
}
