# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 pypy pypy3 )
inherit distutils-r1

DESCRIPTION="Tools for interacting with Intel's AMT"
HOMEPAGE="https://github.com/sdague/amt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-python/appdirs
	dev-python/requests"
DEPEND="${RDEPEND}"
