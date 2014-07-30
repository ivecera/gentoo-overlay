# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

PYTHON_DEPEND="2"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* 2.5-jython"
SUPPORT_PYTHON_ABIS="1"

inherit eutils distutils python linux-info

DESCRIPTION="The targetcli administration shell"
HOMEPAGE="https://github.com/Datera/targetcli"
SRC_URI="https://github.com/Datera/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-python/configshell
	=dev-python/rtslib-2*
	sys-block/lio-utils
	"
RDEPEND="${DEPEND}"

CONFIG_CHECK="~TARGET_CORE"

pkg_setup() {
	linux-info_pkg_setup
	python_pkg_setup
}
