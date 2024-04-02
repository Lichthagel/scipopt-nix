{
  pkgs ? import <nixpkgs> { },
  scip ? pkgs.callPackage ./scip.nix { },
}:
pkgs.stdenv.mkDerivation rec {
  pname = "scippp";
  version = "1.1.0";

  src = pkgs.fetchFromGitHub {
    owner = "scipopt";
    repo = "SCIPpp";
    rev = "${version}";
    sha256 = "sha256-3BsFUpPYMxVhqpaBfqtt/TJnqeRM94BLsMUdoA2Vk5E=";
  };

  nativeBuildInputs = with pkgs; [ cmake ];

  buildInputs = with pkgs; [
    boost
    scip
  ];

  enableParallelBuilding = true;
  doCheck = true;
}
