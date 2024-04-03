{
  description = "My Optimization Project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    scipopt-nix = {
      url = "git+ssh://git@git.or.rwth-aachen.de/jgatzweiler/scipopt-nix?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
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
        packages.default = pkgs.stdenv.mkDerivation {
          name = "my-optimization-project";

          src = ./.;

          nativeBuildInputs = with pkgs; [cmake];

          buildInputs = [inputs'.scipopt-nix.packages.scip];
        };
      };
    };
}
