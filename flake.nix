{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nmd.url = "gitlab:rycee/nmd";
    nmd.flake = false;
  };

  outputs = { self, nixpkgs, nmd }@inputs: {
    lib = with nixpkgs.lib; {
      forAllSystems = f: genAttrs platforms.all f;
    };

    packages = self.lib.forAllSystems (system: rec {
      modules = [
        ./module.nix
        ({ config, ... }: {
          nixpkgs = { inherit system; path = nixpkgs.outPath; };
          _module.args.pkgs = config.nixpkgs.pkgs;
        })
      ];
      nle = nixpkgs.lib.evalModules { inherit modules; };
      pkgs = nle.config.nixpkgs.pkgs;
      defaultPackage.${system} = pkgs.hello;
      nmd = import inputs.nmd { inherit pkgs; };
      doc = nmd.buildModulesDocs {
        modules = [{ }];
        moduleRootPaths = [ ];
        mkModuleUrl = x: x;
        channelName = "channelName";
        docBook = { id = "myproject-options"; optionIdPrefix = "mp-opt"; };
      };
    });
  };
}
