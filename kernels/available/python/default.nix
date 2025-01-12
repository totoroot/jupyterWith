{
  self,
  pkgs,
  name ? "python",
  displayName ? "Python3",
  # https://github.com/nix-community/poetry2nix#mkPoetryEnv
  projectDir ? self + "/kernels/available/python",
  pyproject ? projectDir + "/pyproject.toml",
  poetrylock ? projectDir + "/poetry.lock",
  overrides ? pkgs.poetry2nix.overrides.withDefaults (import ./overrides.nix),
  python ? pkgs.python3,
  editablePackageSources ? {},
  extraPackages ? ps: [],
  preferWheels ? false,
}: let
  env = pkgs.poetry2nix.mkPoetryEnv {
    inherit
      projectDir
      pyproject
      poetrylock
      overrides
      python
      editablePackageSources
      extraPackages
      preferWheels
      ;
  };
in {
  inherit name displayName;
  language = "python";
  argv = [
    "${env}/bin/python"
    "-m"
    "ipykernel_launcher"
    "-f"
    "{connection_file}"
  ];
  codemirrorMode = "python";
  logo64 = ./logo64.png;
}
