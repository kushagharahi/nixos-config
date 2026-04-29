{
  pkgs,
  lib,
  ...
}: let
  # This tells Nix to look at the directory containing THIS file
  scriptDir = ./.;

  scriptFiles = builtins.attrNames (builtins.readDir scriptDir);

  myCustomScripts = map (
    file: let
      name = lib.removeSuffix ".sh" file;
    in
      pkgs.writeShellScriptBin name (builtins.readFile "${scriptDir}/${file}")
  ) (builtins.filter (lib.hasSuffix ".sh") scriptFiles);
in {
  home.packages = myCustomScripts;
}
