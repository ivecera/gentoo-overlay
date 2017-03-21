# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
DISTUTILS_SINGLE_IMPL="1"

inherit eutils distutils-r1 linux-info

MY_PV="${PV/_/-}"
DESCRIPTION="The targetcli administration shell"
HOMEPAGE="https://github.com/Datera/targetcli"
SRC_URI="https://github.com/Datera/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-python/configshell
	dev-python/prettytable
	=dev-python/rtslib-${PV}
	!sys-block/lio-utils
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

CONFIG_CHECK="~TARGET_CORE"

pkg_setup() {
	linux-info_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	sed -e "s,GIT_VERSION,${PV},g" -i ${PN}/__init__.py || die

	distutils-r1_src_prepare || die
}

src_install() {
	distutils-r1_src_install || die

	dodoc COPYING
	doman doc/${PN}.8
	keepdir /etc/target
	keepdir /var/target/pr
	keepdir /var/target/alua
	newinitd "${FILESDIR}/target.initd" target
}
