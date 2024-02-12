{pkgs ? import <nixpkgs> {}, ...}:
pkgs.fetchzip rec {
  pname = "scipoptsuite-src";
  version = "8.1.0";

  name = "${pname}-${version}";

  url = "https://scipopt.org/download/release/scipoptsuite-${version}.tgz";
  hash = "sha256-UjEYFcKsfBbBN25xxWFRIdZzenUk2Ooev8lz2eQtzTk=";
}
