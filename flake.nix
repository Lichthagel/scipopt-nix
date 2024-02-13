{
  description = "SCIP Optimization Suite";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];

      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: {
        packages = rec {
          gcg = pkgs.callPackage ./gcg.nix {
            inherit scip;
          };
          scip = pkgs.callPackage ./scip.nix {
            inherit soplex papilo zimpl;
            ipopt = null; # explicitly disable ipopt, since libhsl is not found...
          };
          soplex = pkgs.callPackage ./soplex.nix {};
          papilo = pkgs.callPackage ./papilo.nix {
            inherit soplex;
          };
          zimpl = pkgs.callPackage ./zimpl.nix {};

          pyscipopt = pkgs.python3Packages.callPackage ./pyscipopt.nix {
            inherit scip;
          };
          pygcgopt = pkgs.python3Packages.callPackage ./pygcgopt.nix {
            inherit scip gcg pyscipopt;
          };

          default = scip;
        };
      };
    };
}
