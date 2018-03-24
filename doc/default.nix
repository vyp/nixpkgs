let
  pkgs = import ./.. { };
  lib = pkgs.lib;
  sources = lib.sourceFilesBySuffices ./. [".xml"];
  sources-langs = ./languages-frameworks;
in
pkgs.stdenv.mkDerivation {
  name = "nixpkgs-manual";

  buildInputs = with pkgs; [ pandoc libxml2 libxslt zip ];

  src = ./.;

  XSL = "${pkgs.docbook5_xsl}/xml/xsl";
  RNG = "${pkgs.docbook5}/xml/rng/docbook/docbook.rng";
  xsltFlags = lib.concatStringsSep " " [
    "--param section.autolabel 1"
    "--param section.label.includes.component.label 1"
    "--param html.stylesheet 'style.css'"
    "--param xref.with.number.and.title 1"
    "--param toc.section.depth 3"
    "--param admon.style ''"
    "--param callout.graphics.extension '.gif'"
  ];

  postPatch = ''
    echo ${lib.nixpkgsVersion} > .version
  '';

  installPhase = ''
    dest="$out/share/doc/nixpkgs"
    mkdir -p "$(dirname "$dest")"
    mv out/html "$dest"
    mv "$dest/index.html" "$dest/manual.html"

    mv out/epub/manual.epub "$dest/nixpkgs-manual.epub"

    mkdir -p $out/nix-support/
    echo "doc manual $dest manual.html" >> $out/nix-support/hydra-build-products
  '';
}
