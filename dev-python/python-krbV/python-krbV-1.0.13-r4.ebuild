# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit python eutils

DESCRIPTION="Python extension module for Kerberos 5"
HOMEPAGE="http://people.redhat.com/mikeb/python-krbV"
SRC_URI="http://people.redhat.com/mikeb/${PN}/${P}.tar.gz"

RESTRICT="mirror"
LICENSE="LGPL"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="virtual/krb5"
RDEPEND="${DEPEND}"

src_compile() {
	emake pythondir=$(python_get_sitedir)
}

src_install() {
	emake install DESTDIR="${D}" pythondir=$(python_get_sitedir) || \
		die "Install failed"
	rm -vf "${D}/$(python_get_sitedir)/krbVmodule.la"
	dodoc README COPYING krbV-code-snippets.py
}

