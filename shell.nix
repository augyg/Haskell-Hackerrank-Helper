{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, array, attoparsec, base, base-prelude
      , base-unicode-symbols, basic-prelude, bifunctors, bytestring
      , comonad, deepseq, dlist, either, hashtables, lens, lens-aeson
      , lib, logict, matrix, memoize, MemoTrie, monad-memo, parsec, pipes
      , random, regex-applicative, regex-base, regex-compat
      , regex-pcre-builtin, regex-posix, regex-tdfa, split, text, threads
      , unordered-containers, vector
      }:
      mkDerivation {
        pname = "hackerrank";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [
          aeson array attoparsec base base-prelude base-unicode-symbols
          basic-prelude bifunctors bytestring comonad deepseq dlist either
          hashtables lens lens-aeson logict matrix memoize MemoTrie
          monad-memo parsec pipes random regex-applicative regex-base
          regex-compat regex-pcre-builtin regex-posix regex-tdfa split text
          threads unordered-containers vector
        ];
        license = "unknown";
        hydraPlatforms = lib.platforms.none;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
