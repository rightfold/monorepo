{ pkgs ? import ./nix/pkgs.nix {} }:
let
    semilattice = {
        uphub = pkgs.callPackage ./uphub {};
    };
in
    semilattice
