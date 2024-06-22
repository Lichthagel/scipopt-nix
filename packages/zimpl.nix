{
  pkgs ? import <nixpkgs> {},
  lib ? import <nixpkgs/lib> {},
  scipoptsuite-src ? pkgs.callPackage ./scipoptsuite-src.nix {},
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "zimpl";
  version = "3.6.1";

  # Not publicly available apart from the SCIP Optimization Suite
  src = assert (
    lib.strings.versionAtLeast scipoptsuite-src.version "9.1.0"
    && lib.strings.versionOlder scipoptsuite-src.version "9.1.1"
  ); "${scipoptsuite-src}/zimpl"; # check for scipopt suite version that ships correct zimpl version

  nativeBuildInputs = with pkgs; [
    cmake
    bison
    flex
  ];

  buildInputs = with pkgs; [
    gmp
    zlib
  ];

  outputs = [
    "bin"
    "dev"
    "out"
  ];

  patches = [../patches/zimpl_dirs.patch];

  meta = {
    description = "Mathematical modeling language for linear or (mixed-)integer programs";
    homepage = "https://zimpl.zib.de/";
    license = lib.licenses.lgpl3;
  };
}
