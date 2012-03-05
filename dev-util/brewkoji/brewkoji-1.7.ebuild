# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit python eutils

DESCRIPTION="Brew compatibility interface for koji"
SRC_URI="${P}.tar.bz2"

HOMEPAGE="http://www.redhat.com/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="fetch mirror"
IUSE=""

DEPEND="dev-lang/python"
RDEPEND="${DEPEND}
	dev-util/koji"

src_compile() {
	return 0
}

src_install() {
	cd "${S}"
	emake -j1 DESTDIR="${D}" PKGDIR="$(python_get_sitedir)/${PN}" -C lib install
	emake -j1 DESTDIR="${D}" -C cli install
	dodoc README
}

