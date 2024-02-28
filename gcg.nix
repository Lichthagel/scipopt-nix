{
  pkgs ? import <nixpkgs> {},
  lib ? import <nixpkgs/lib> {},
  scip ? pkgs.callPackage ./scip.nix {},
  scipoptsuite-src ? pkgs.callPackage ./scipoptsuite-src.nix {},
  ...
}:
pkgs.stdenv.mkDerivation {
  pname = "gcg";
  version = "3.6.0";

  src = assert (
    lib.strings.versionAtLeast scipoptsuite-src.version "9.0.0"
    && lib.strings.versionOlder scipoptsuite-src.version "9.0.1"
  ); "${scipoptsuite-src}/gcg"; # check for scipopt suite version that ships correct zimpl version

  nativeBuildInputs = with pkgs; [
    cmake
  ];

  buildInputs =
    (with pkgs; [
      cliquer
      gmp
      gsl
      (bliss.overrideAttrs (oldAttrs: {
        installPhase =
          oldAttrs.installPhase
          + ''
            mv $out/lib/libbliss.a $out/lib/liblibbliss.a
          '';
      }))
    ])
    ++ [scip];

  enableParallelBuilding = true;
  doCheck = true;
}
