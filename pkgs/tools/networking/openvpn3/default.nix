{ lib
, stdenv
, fetchFromGitHub

# buildtime
, autoreconfHook
, autoconf-archive
, docutils
, jinja2
, git
, pkg-config
, lz4
, jsoncpp
, glib
, libuuid
, libcap_ng
, openssl
, tinyxml-2

# runtime
, python3
}:

stdenv.mkDerivation rec {
  pname = "openvpn3";
  version = "17_beta";

  src = fetchFromGitHub {
    owner = "OpenVPN";
    repo = "openvpn3-linux";
    rev = "v${version}";
    fetchSubmodules = true;
    leaveDotGit = true;
    sha256 = "0bvzxssw4vjjr2lvri2mw9x1fpx91rc0kjfplifp24n41krdxpf4";
  };

  postPatch = ''
    ./update-version-m4.sh
    patchShebangs ./openvpn3-core/scripts/version
  '';

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    docutils
    git
    jinja2
    pkg-config
  ];

  buildInputs = [
    lz4
    jsoncpp
    glib
    libuuid
    libcap_ng
    openssl
    tinyxml-2
  ];

  propagatedbuildinputs = [
    python3
  ];

  configureFlags = [ "--disable-selinux-build" ];

  NIX_LDFLAGS = "-lpthread";

  meta = with lib; {
    description = "OpenVPN 3 Linux client";
    license = licenses.agpl3Plus;
    homepage = "https://github.com/OpenVPN/openvpn3-linux/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
