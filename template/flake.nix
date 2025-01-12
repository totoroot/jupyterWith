{
  description = "Your jupyterWith project";

  nixConfig.extra-substituters = [
    "https://tweag-jupyter.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
  ];

  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.jupyterWith.url = "github:tweag/jupyterWith";

  outputs = {
    self,
    flake-compat,
    flake-utils,
    jupyterWith,
  }:
    flake-utils.lib.eachSystem
    [
      flake-utils.lib.system.x86_64-linux
    ]
    (
      system: let
        inherit (jupyterWith.lib.${system}) mkJupyterlabEnvironmentFromPath;
        jupyterEnvironment = mkJupyterlabEnvironmentFromPath ./kernels;
      in rec {
        packages = {inherit jupyterEnvironment;};
        packages.default = jupyterEnvironment;
        apps.default.program = "${jupyterEnvironment}/bin/jupyter-lab";
        apps.default.type = "app";
      }
    );
}
