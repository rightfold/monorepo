{ callPackage }:
{
    database = callPackage ./database {};
    uphubconf = callPackage ./uphubconf {};
    uphubd = callPackage ./uphubd {};
}
