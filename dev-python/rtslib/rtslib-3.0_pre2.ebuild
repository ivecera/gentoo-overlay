# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* 2.5-jython"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils python

MY_PV="${PV/_/-}"
DESCRIPTION="Python API to the Linux Kernel's SCSI Target subsystem (LIO)"
HOMEPAGE="https://github.com/Datera/rtslib"
SRC_URI="https://github.com/Datera/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/configobj
	dev-python/ipaddr
	dev-python/netifaces
	dev-python/pyparsing
	"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	sed -e "s,GIT_VERSION,${PV},g" -i ${PN}/__init__.py || die

	distutils_src_prepare || die
}

src_install() {
	distutils_src_install || die

	dodoc COPYING specs/*.txt

	keepdir /var/target/fabric
	insinto /var/target/fabric
	doins specs/*.spec

	keepdir /var/target/policy
	insinto /var/target/policy
	doins policy/*.lio
}
