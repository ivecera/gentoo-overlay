# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* 2.5-jython"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils python

DESCRIPTION="Python API to the Linux Kernel's SCSI Target subsystem (LIO)"
HOMEPAGE="https://github.com/Datera/rtslib"
SRC_URI="https://github.com/Datera/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-python/configobj
	dev-python/ipaddr
	dev-python/netifaces
	"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s,GIT_VERSION,${PV},g" -i ${PN}/__init__.py || die

	distutils_src_prepare || die
}

src_install() {
	distutils_src_install || die

	dodoc COPYING
	keepdir /var/target/fabric
	insinto /var/target/fabric
	doins specs/*.spec
}
