{ stdenv, fetchurl, pkgconfig, guile, ncurses, libffi }:

let
  name = "${pname}-${version}";
  pname = "guile-ncurses";
  version = "2.2";
in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://gnu/${pname}/${name}.tar.gz";
    sha256 = "1wvggbr4xv8idh1hzd8caj4xfp4pln78a7w1wqzd4zgzwmnzxr2f";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ guile ncurses libffi ];

  preConfigure = ''
    configureFlags="$configureFlags --with-guilesitedir=$out/share/guile/site"
  '';

  postFixup = ''
    for f in $out/share/guile/site/ncurses/**.scm; do \
      substituteInPlace $f \
        --replace "libguile-ncurses" "$out/lib/libguile-ncurses"; \
    done
  '';

  # XXX: 1 of 65 tests failed.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Scheme interface to the NCurses libraries";
    longDescription = ''
      GNU Guile-Ncurses is a library for the Guile Scheme interpreter that
      provides functions for creating text user interfaces.  The text user
      interface functionality is built on the ncurses libraries: curses, form,
      panel, and menu.
    '';
    homepage = "https://www.gnu.org/software/guile-ncurses/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.gnu;
  };
}
