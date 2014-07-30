# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* 2.5-jython"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils python

DESCRIPTION="A Python framework for building CLI interfaces and shells"
HOMEPAGE="https://github.com/Datera/configshell"
SRC_URI="https://github.com/Datera/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-python/epydoc
	dev-python/simpleparse
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
