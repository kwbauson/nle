let
  pkgs = (builtins.getFlake (toString ./.)).packages.${builtins.currentSystem};
in
pkgs // pkgs.nle._module.args
