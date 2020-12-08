# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_7 python3_8 )
PYTHON_REQ_USE='threads(+)'

inherit python-single-r1 waf-utils

DESCRIPTION="Opengl test suite"
HOMEPAGE="https://github.com/glmark2/glmark2"
SRC_URI="https://github.com/glmark2/glmark2/archive/2020.04.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE="drm gles2 +opengl wayland X"

RDEPEND="
	>=media-libs/libpng-1.2
	media-libs/mesa[gles2?]
	X? ( x11-libs/libX11 )
	wayland? ( >=dev-libs/wayland-1.2 )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

REQUIRED_USE="
	|| ( opengl gles2 )
	|| ( drm wayland X )"

src_prepare() {
	epatch "${FILESDIR}/01-Build-Fix-Python-3-incompatibility.patch"
	rm -rf "${S}/src/libjpeg-turbo"
	rm -rf "${S}/src/libpng"
	rm -rf "${S}/src/zlib"
}

src_configure() {
	#: ${WAF_BINARY:="${S}/waf"}

	local myconf

	if use X; then
		use opengl && myconf+="x11-gl"
		use gles2 && myconf+=",x11-glesv2"
	fi

	if use drm; then
		use opengl && myconf+=",drm-gl"
		use gles2 && myconf+=",drm-glesv2"
	fi

	if use wayland; then
		use opengl && myconf+=",wayland-gl"
		use gles2 && myconf+=",wayland-glesv2"

	fi
	myconf=${myconf#,}

	waf-utils_src_configure --with-flavors ${myconf} || die "configure failed"
}
