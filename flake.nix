{
  description = "SCIP Optimization Suite";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    systems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    eachSystems = f:
      nixpkgs.lib.genAttrs systems (
        system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
            selfPkgs = self.packages.${system};
          }
      );
  in {
    templates = import ./templates;

    packages = eachSystems (
      import ./packages
    );

    devShells = eachSystems (
      {
        system,
        pkgs,
        ...
      }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            self.formatter.${system}
            just
            nvfetcher
            deadnix
            statix
          ];
        };
      }
    );

    formatter = eachSystems (
      {pkgs, ...}: pkgs.alejandra
    );

    checks = eachSystems (perSystemInputs: import ./checks ({inherit self nixpkgs;} // perSystemInputs));
  };
}
