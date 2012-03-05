# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit waf-utils

DESCRIPTION="Opengl test suite"
HOMEPAGE="https://launchpad.net/glmark2"
SRC_URI="http://launchpad.net/${PN}/2011.11/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libpng
	media-libs/mesa
	x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	rm -rf "${S}/src/libpng"
	sed -i -e 's#libpng12#libpng#g' "${S}/wscript" "${S}/src/wscript_build" \
		|| die
	sed -i -e 's#voidp#void*#g' "${S}/src/texture.cpp" || die
}

src_configure() {
	: ${WAF_BINARY:="${S}/waf"}

	# it does not know --libdir specification, dandy huh
	CCFLAGS="${CFLAGS}" LINKFLAGS="${LDFLAGS}" "${WAF_BINARY}" \
		--prefix=/usr \
		--enable-gl \
		configure || die "configure failed"
}
