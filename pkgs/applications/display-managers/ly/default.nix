{ stdenv
, fetchFromGitHub
, libxcb
, linux-pam
, ncurses
, termbox_next
, utillinux
, xauth
, xorgserver
}:

stdenv.mkDerivation rec { 
  pname = "ly";
  version = "unstable-2019-10-05";

  srcs = [
    (fetchFromGitHub {
      owner = "cylgom";
      repo = "argoat";
      rev = "36c41f09ecc2a10c9acf35e4194e08b6fa10cf45";
      sha256 = "14v01fwm2bcgqh5b25iqfy4dm8pap8r49r1yfsr5c9j3b3hfn4yg";
      name = "argoat";
    })
    (fetchFromGitHub {
      owner = "cylgom";
      repo = "configator";
      rev = "c3e1ef175418ccb5b0981ae64ec6f5ae4a60fbaf";
      sha256 = "0njzqkfp8hqdcx3g0i6r5jv7l7k62a8mqbv1abbc88mg52dk4wyz";
      name = "configator";
    })
    (fetchFromGitHub {
      owner = "cylgom";
      repo = "ctypes";
      rev = "5dd979d3644ab0c85ca14e72b61e6d3d238d432b";
      sha256 = "0faahn2wgckhf3pyn9za594idy9gc5fxdm02ghn6mm3r4fk34xyx";
      name = "ctypes";
    })
    (fetchFromGitHub {
      owner = "cylgom";
      repo = "dragonfail";
      rev = "6b40d1f8b7f6dda9746e688666af623dfbcceb94";
      sha256 = "0slsqw6q859vg0h0w92mmjwwh8m65m09h7pq59p90ixrga5q7jch";
      name = "dragonfail";
    })
    (fetchFromGitHub {
      owner = "cylgom";
      repo = "ly";
      rev = "d839a9229640bb17a59b6cfc5ba3c9119ea56a7d";
      sha256 = "0bx2c02ip9b76452r5svlmyvh4m3bqavl454ns5mgn2ykx9j52py";
      name = "ly";
    })
  ];

  buildInputs = [
    libxcb
    linux-pam
    ncurses
    termbox_next
    utillinux
    xauth
    xorgserver
  ];

  inherit termbox_next;
  sourceRoot = ".";

  postUnpack = ''
    rmdir ly/sub/argoat
    rmdir ly/sub/configator
    rmdir ly/sub/ctypes
    rmdir ly/sub/dragonfail
    mv argoat ly/sub
    mv configator ly/sub
    mv ctypes ly/sub
    mv dragonfail ly/sub
    mkdir -p ly/sub/termbox_next/bin
    cp $termbox_next/lib/termbox.a ly/sub/termbox_next/bin
  '';

  preBuild = ''
    cd ly
    substituteInPlace makefile --replace "FLAGS+= -DGIT_VERSION_STRING=" " # "
  '';

  # substituteInPlace makefile --replace \
  #   "SRCS_OBJS+= $(SUBD)/termbox_next/bin/termbox.a"
  #   "SRCS_OBJS+= $termbox_next/lib/termbox.a"

  makeFlags = [ "DESTDIR=$(out)" "FLAGS=-Wno-error" ];

  installPhase = ''
    mkdir -p $out/bin
    cp bin/ly $out/bin 
  '';

  meta = with stdenv.lib; {
    description = "TUI display manager";
    homepage = "https://github.com/cylgom/ly";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ spacekookie vyp ];
  };
}
