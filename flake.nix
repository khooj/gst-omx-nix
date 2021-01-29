{
  description = "Gstreamer OMX API Wrapper";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
  flake-utils.lib.eachDefaultSystem (system: 
  let
    pkgs = import nixpkgs {
      system = "aarch64-linux";
    };
  in {
    defaultPackage = pkgs.callPackage ./default.nix {};
  });
}
