{ stdenv, php }:
stdenv.mkDerivation rec {
    name = "psalm";
    src = builtins.fetchurl {
        url = https://github.com/vimeo/psalm/releases/download/3.0.11/psalm.phar;
        sha256 = "1y5lg3il3dvbfsl900cwy8ainar4phkcnpivj3cvr6g2w0rlqxjl";
    };
    buildInputs = [php];
    phases = ["installPhase"];
    installPhase = ''
        mkdir -p $out/bin $out/share
        cp ${src} $out/share/psalm.phar
        cat <<EOF > "$out/bin/psalm"
        #!/bin/sh
        export PATH="${php}/bin:\$PATH"
        exec php $out/share/psalm.phar "\$@"
        EOF
        chmod +x $out/bin/psalm
    '';
}
