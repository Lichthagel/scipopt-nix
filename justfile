build PACKAGE:
  nix build -vL .\#{{PACKAGE}}

run PACKAGE:
  nix run -vL .\#{{PACKAGE}}

update:
  nix flake update
  nvfetcher

format:
  alejandra ./*.nix ./templates/*/*.nix

check:
  statix check .
  nix flake check --all-systems