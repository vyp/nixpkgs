{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "termbox_next";
  version = "unstable-2019-10-28";

  src = fetchFromGitHub {
    owner = "cylgom";
    repo = pname;
    rev = "2312da153e44face7bb45aa2798ec284289c17ca";
    sha256 = "0qymcg8yha72vmqc8s23n3m4qxa1j7drfm0qmvfimwf804nfhhb5";
  };

  installPhase = ''
    mkdir -p $out/lib
    mkdir -p $out/include
    cp bin/termbox.a $out/lib
    cp src/termbox.h $out/include
  '';

  meta = with stdenv.lib; {
    description = "Library for writing text-based user interfaces";
    homepage = "https://github.com/cylgom/termbox_next";
    license = licenses.mit;
    maintainers = with maintainers; [ vyp ];
    platforms = platforms.linux;
  };
}
