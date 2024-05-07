# scipopt-nix

Nix flake and expressions for tools from the SCIP Optimization Suite.

## Packages

The following packages are provided: scip, gcg, soplex, papilo, zimpl, pysoplex, pyscipopt, pygcgopt, scippp.

## Usage

When using flakes, add

```nix
scipopt-nix = {
  url = "github:Lichthagel/scipopt-nix";
  # or "gitlab:jgatzweiler/scipopt-nix?host=git.or.rwth-aachen.de"
  inputs.nixpkgs.follows = "nixpkgs";
};
```

to your inputs.

## Templates

This repository contains some templates to get you started.

| name      | description                                       |
| --------- | ------------------------------------------------- |
| scip      | An optimization project using SCIP in C (or C++)  |
| gcg       | An optimization project using GCG in C (or C++)   |
| pyscipopt | An optimization project using PySCIPOpt in Python |
| pygcgopt  | An optimization project using PyGCGOpt in Python  |

To use a template, run

```sh
nix flake init -t "github:Lichthagel/scipopt-nix#<template>"
```

where `<template>` is one of the names in the table above.

## Working on SCIP/GCG

If you are working on a local copy or fork of SCIP/GCG you may want to use something like this:

```nix
{
  description = "SCIP";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    scipopt-nix = {
      url = "github:Lichthagel/scipopt-nix";
      # url = "gitlab:jgatzweiler/scipopt-nix?host=git.or.rwth-aachen.de";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      scipopt-nix,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      eachSystems =
        f:
        nixpkgs.lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
            selfPkgs = self.packages.${system};
            scipoptPkgs = scipopt-nix.packages."${system}";
          }
        );
    in
    {
      packages = eachSystems (
        { scipoptPkgs, ... }:
        {
          default = scipoptPkgs.scip.overrideAttrs (oldAttrs: {
            src = ./.;
          });
        }
      );

      devShells = eachSystems (
        { pkgs, selfPkgs, ... }:
        {
          default = pkgs.mkShell {
            name = "scip-dev";

            packages = with pkgs; [
              gdb
              ninja
              clang
              cppcheck
              valgrind
            ];

            inputsFrom = [ selfPkgs.default ];
          };
        }
      );
    };
}
```
