{pkgs ? import <nixpkgs> {}, ...}: let
  suite-src = pkgs.fetchzip {
    url = "https://scipopt.org/download/release/scipoptsuite-8.1.0.tgz";
    hash = "sha256-UjEYFcKsfBbBN25xxWFRIdZzenUk2Ooev8lz2eQtzTk=";
  };
in
  pkgs.stdenv.mkDerivation {
    pname = "zimpl";
    version = "3.5.3";

    # Not publicly available apart from the SCIP Optimization Suite
    src = "${suite-src}/zimpl";

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
