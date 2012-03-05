# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit python eutils

DESCRIPTION="RPMs build system tools"
HOMEPAGE="http://fedorahosted.org/koji"
SRC_URI="https://fedorahosted.org/releases/k/o/koji/${P}.tar.bz2"

RESTRICT="mirror"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/rpm[python]
	dev-python/pyopenssl
	>=dev-python/python-krbV-1.0.13
	dev-python/urlgrabber"

src_compile() {
	return 0
}

src_install() {
	emake -j1 DESTDIR="${D}" PKGDIR="$(python_get_sitedir)/${PN}" -C koji \
		install
	dodir /etc
	emake -j1 DESTDIR="${D}" -C cli install
	dodoc docs/HOWTO.html docs/schema.sql docs/schema-upgrade-1.2-1.3.sql
}
