# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
DISTUTILS_SINGLE_IMPL="1"

inherit eutils distutils-r1

MY_PV="${PV/_/-}"
DESCRIPTION="Python API to the Linux Kernel's SCSI Target subsystem (LIO)"
HOMEPAGE="https://github.com/Datera/rtslib"
SRC_URI="https://github.com/Datera/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
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

	distutils-r1_src_prepare || die

	epatch "${FILESDIR}/pyparsing_fix.patch"
}

src_install() {
	distutils-r1_src_install || die

	dodoc COPYING specs/*.txt

	keepdir /var/target/fabric
	insinto /var/target/fabric
	doins specs/*.spec

	keepdir /var/target/policy
	insinto /var/target/policy
	doins policy/*.lio
}
