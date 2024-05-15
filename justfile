build PACKAGE:
  nix build -vL .\#{{PACKAGE}}

run PACKAGE:
  nix run -vL .\#{{PACKAGE}}

update:
  nix flake update
  nvfetcher

format:
  alejandra ./*.nix ./templates/*/*.nix ./checks/*.nix

check:
  nix flake check