{ stdenv, sqitchPg }:
{
    self = stdenv.mkDerivation {
        name = "uphub_database";
        buildInputs = [
            sqitchPg
        ];
        shellHook = ''
            cd uphub/database
        '';
    };
}
