# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit flag-o-matic qt3

DESCRIPTION="Editor for manipulating PDF documents. GUI and commandline interface."
HOMEPAGE="http://pdfedit.petricek.net/"
SRC_URI="mirror://sourceforge/pdfedit/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+manual"

RDEPEND="
	media-libs/freetype:2
	media-libs/t1lib
	x11-libs/qt:3"
DEPEND="${RDEPEND}
	dev-libs/boost
	manual? ( app-text/docbook-xml-dtd:4.2 dev-libs/libxslt )"

src_prepare() {
	# Prevent overwriting the users' C{,XX}FLAGS
	sed -i 's/^\(CONFIG_CFLAGS\).*@/\1 = @CFLAGS@/' Makefile.flags.in
	sed -i 's/^\(CONFIG_CXXFLAGS\).*@/\1 = @CXXFLAGS@/' Makefile.flags.in

	# Prevent overwriting the users' MAKEOPTS
	sed -i 's/@parallel_make@/$(MAKEOPTS)/' Makefile.rules.in
}

src_configure() {
	append-flags "-fno-strict-aliasing"
	econf --docdir=/usr/share/doc/${PF} \
		$(use_enable manual user-manual)
}

src_install () {
	emake INSTALL_ROOT="${D}" install || die "emake failed"
}
