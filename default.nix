{ lib, stdenv, fetchurl, meson, nasm, ninja, pkg-config, python3, orc, bzip2
, gettext, libv4l, libdv, libavc1394, libiec61883, libvpx, speex, flac, taglib
, libshout, cairo, gdk-pixbuf, aalib, libcaca, libsoup, libpulseaudio, libintl
, darwin, lame, mpg123, twolame, libraspberrypi, libXdamage, libXext, libXfixes
, libgudev, wavpack, fetchFromGitHub, gst_all_1, cmake }:

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
    ];

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
    platforms = [ "aarch64-linux" ];
    maintainers = with maintainers; [ ];
  };
}
