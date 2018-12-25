{ stdenv, phpPackages }:
{
    self = stdenv.mkDerivation {
        name = "uphubconf";
        src = ./.;
        buildInputs = [
            phpPackages.composer
            phpPackages.psalm
        ];
        buildPhase = ''
            composer dump-autoload
            psalm
        '';
        installPhase = ''
            mkdir "$out"
            cp -R 'boot' 'src' 'vendor' "$out"
        '';
    };
}
