{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default =
          with pkgs;
          pkgs.mkShell rec {
            # lua 5.1 is luanti's default lua version.
            buildInputs = [
              luanti-client
              lua51Packages.lua
              lua51Packages.luacheck
              stylua
              typst
            ];

            LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";

          };
      }
    );
}
