{pkgs ? import <nixpkgs> {}, ...}:
pkgs.fetchzip rec {
  pname = "scipoptsuite-src";
  version = "9.1.0";

  name = "${pname}-${version}";

  url = "https://scipopt.org/download/release/scipoptsuite-${version}.tgz";
  hash = "sha256-30rxnlP1DuMo0/F3mDDwpGeTKCzf7B0nsUsfSY/lB54=";
}
