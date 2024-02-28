{pkgs ? import <nixpkgs> {}, ...}:
pkgs.fetchzip rec {
  pname = "scipoptsuite-src";
  version = "9.0.0";

  name = "${pname}-${version}";

  url = "https://scipopt.org/download/release/scipoptsuite-${version}.tgz";
  hash = "sha256-Dxp6CvEdaT3NHyftjn4Tl/ps0OMjP08nJJl7bHihRns=";
}
