{
  pkgs ? import <nixpkgs> {},
  lib ? import <nixpkgs/lib> {},
  ...
}: let
  zimpl-src =
    (import ../_sources/generated.nix {
      inherit
        (pkgs)
        fetchgit
        fetchurl
        fetchFromGitHub
        dockerTools
        ;
    })
    .zimpl;
in
  pkgs.stdenv.mkDerivation {
    pname = "zimpl";

    inherit (zimpl-src) src version;

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
