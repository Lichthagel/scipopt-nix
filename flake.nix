{
  description = "SCIP Optimization Suite";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        scip = {
          path = ./templates/scip;
          description = "An optimization project using SCIP in C (or C++)";
        };

        gcg = {
          path = ./templates/gcg;
          description = "An optimization project using GCG in C (or C++)";
        };

        pyscipopt = {
          path = ./templates/pyscipopt;
          description = "An optimization project using PySCIPOpt in Python";
        };

        pygcgopt = {
          path = ./templates/pygcgopt;
          description = "An optimization project using PyGCGOpt in Python";
        };
      };

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        packages = rec {
          gcg = pkgs.callPackage ./gcg.nix {inherit scip;};
          scip = pkgs.callPackage ./scip.nix {
            inherit soplex papilo zimpl;
            ipopt = null; # explicitly disable ipopt, since libhsl is not found...
          };
          soplex = pkgs.callPackage ./soplex.nix {};
          papilo = pkgs.callPackage ./papilo.nix {inherit soplex;};
          zimpl = pkgs.callPackage ./zimpl.nix {};

          pysoplex = pkgs.python3Packages.callPackage ./pysoplex.nix {};
          pyscipopt = pkgs.python3Packages.callPackage ./pyscipopt.nix {inherit scip;};
          pygcgopt = pkgs.python3Packages.callPackage ./pygcgopt.nix {inherit scip gcg pyscipopt;};

          scippp = pkgs.callPackage ./scippp.nix {inherit scip;};

          default = scip;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            just
            nil
            nvfetcher
            statix
          ];
        };
      };
    };
}
