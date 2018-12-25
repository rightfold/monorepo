{ haskellPackages }:
{
    self = haskellPackages.mkDerivation {
        pname = "uphubd";
        version = "0.0.0.0";
        license = null;
        src = ./.;
        buildDepends = [
            haskellPackages.base
            haskellPackages.bytestring
            haskellPackages.optparse-applicative
            haskellPackages.postgresql-libpq
            haskellPackages.resource-pool
            haskellPackages.serialise
            haskellPackages.zeromq4-haskell
        ];
    };
}
