# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
DISTUTILS_SINGLE_IMPL="1"

inherit eutils distutils-r1

DESCRIPTION="A Python framework for building CLI interfaces and shells"
HOMEPAGE="https://github.com/Datera/configshell"
SRC_URI="https://github.com/Datera/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="epydoc"

DEPEND="
	epydoc? ( dev-python/epydoc )
	dev-python/pyparsing
	>=dev-python/urwid-0.9.9
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s,GIT_VERSION,${PV},g" -i configshell/__init__.py || die

	distutils_src_prepare || die
}

src_install() {
	distutils_src_install || die

	dodoc COPYING
	dodoc -r examples
}
