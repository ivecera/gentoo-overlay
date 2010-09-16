# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit python eutils

DESCRIPTION="RPMs build system tools"
HOMEPAGE="http://fedorahosted.org/koji"
SRC_URI="https://fedorahosted.org/koji/attachment/wiki/KojiRelease/${P}.tar.bz2?format=raw -> ${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="mirror"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/rpm[python]
	dev-python/pyopenssl
	dev-python/python-krbV
	dev-python/urlgrabber"

src_compile() {
	return 0
}

src_install() {
	cd "${S}"
	emake -j1 DESTDIR="${D}" PKGDIR="$(python_get_sitedir)/${PN}" -C koji \
		install
	dodir /etc
	emake -j1 DESTDIR="${D}" -C cli install
	dodoc docs/HOWTO.html docs/schema.sql docs/schema-upgrade-1.2-1.3.sql
}

