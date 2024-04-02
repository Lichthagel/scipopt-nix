{
  pkgs ? import <nixpkgs> { },
  scip ? pkgs.callPackage ./scip.nix { },
  debugFiles ? [ ], # add `#define SCIP_DEBUG` to these files (e.g. ["src/gcg/cons_decomp.cpp"])
  ...
}:
pkgs.stdenv.mkDerivation rec {
  pname = "gcg";
  version = "3.6.0";

  src = pkgs.fetchFromGitHub {
    owner = "scipopt";
    repo = "gcg";
    rev = "v${builtins.replaceStrings [ "." ] [ "" ] version}";
    sha256 = "sha256-MRgsmP9LuTpS/FEPBNJSrIbYlUGh8EOEcbbl0MVEiRA=";
    leaveDotGit = true;
  };

  nativeBuildInputs = with pkgs; [
    cmake
    git # to obtain git commit hash
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
    ++ [ scip ];

  postPatch = ''
    # Add #define SCIP_DEBUG to debug files
    for file in ${builtins.concatStringsSep " " debugFiles}; do
      sed -i '1s/^/#define SCIP_DEBUG\n/' $file
    done
  '';

  enableParallelBuilding = true;
  doCheck = true;
}
