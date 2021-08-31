{ config, lib, ... }:
with lib;
{
  options = {
    nixpkgs = let cfg = config.nixpkgs; in
      {
        path = mkOption {
          type = types.path;
          description = ''
            Path to nixpkgs collection to be used.
          '';
        };
        system = mkOption {
          type = types.str;
          description = "nixpkgs system";
        };
        config = mkOption {
          default = { };
          type = types.attrs;
          description = "nixpkgs config";
        };
        overlays = mkOption {
          default = [ ];
          type = with types; listOf (listOf (functionTo attrs));
          description = "nixpkgs overlays";
        };
        pkgs = mkOption {
          default = import cfg.path { inherit (cfg) system config overlays; };
          type = types.attrs;
          description = ''
            The final imported nixpkgs set to use. Note that if you set this
            manually `nixpkgs.config` and `nixpkgs.overlays` won't be used.
          '';
        };
      };
  };
}
