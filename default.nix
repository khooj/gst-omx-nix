{ lib, stdenv, fetchurl, meson, nasm, ninja, pkg-config, python3, orc, bzip2
, gettext, libv4l, libdv, libavc1394, libiec61883, libvpx, speex, flac, taglib
, libshout, cairo, gdk-pixbuf, aalib, libcaca, libsoup, libpulseaudio, libintl
, darwin, lame, mpg123, twolame, gtkSupport ? false, gtk3 ? null
, raspiCameraSupport ? false, libraspberrypi , enableJack ? true, libjack2
, libXdamage, libXext, libXfixes, libgudev, wavpack, fetchFromGitHub, gst_all_1, cmake }:

assert gtkSupport -> gtk3 != null;
assert raspiCameraSupport
  -> ((libraspberrypi != null) && stdenv.isLinux && stdenv.isAarch64);

let inherit (lib) optionals;
in stdenv.mkDerivation rec {
  pname = "gst-omx";
  version = "1.18.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "gstreamer";
    repo = "gst-omx";
    rev = "08113f934a2f249ce657b3b09612d6baf2ccf557";
    sha256 = "sha256-/g1iLKPOVZNQbrxiUXKwB6P8f+sRMWJuE4PNEo3BmTw=";
  };

  nativeBuildInputs = [ pkg-config python3 meson ninja gettext nasm ];

  buildInputs = [
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-base
      cmake
      libraspberrypi
    orc
    bzip2
    libdv
    libvpx
    speex
    flac
    taglib
    cairo
    gdk-pixbuf
    aalib
    libcaca
    libsoup
    libshout
    lame
    mpg123
    twolame
    libintl
    libXdamage
    libXext
    libXfixes
    wavpack
  ] ++ optionals raspiCameraSupport [ libraspberrypi ] ++ optionals gtkSupport [
    # for gtksink
    gtk3
  ] ++ optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Cocoa ]
    ++ optionals stdenv.isLinux [
      libv4l
      libpulseaudio
      libavc1394
      libiec61883
      libgudev
    ] ++ optionals enableJack [ libjack2 ];

  mesonFlags = [
    "-Dexamples=disabled"
    "-Ddoc=disabled"
    "-Dheader_path=${libraspberrypi}/include/IL"
    "-Dtarget=rpi"
  ];

  postPatch = ''
    patchShebangs \
      scripts/extract-release-date-from-doap-file.py
  '';

  meta = with lib; {
    description = "GStreamer OpenMax API Wrapper";
    homepage = "https://gstreamer.freedesktop.org";
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
  };
}
