# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CMAKE_MIN_VERSION="2.4"
PYTHON_DEPEND="python? 2:2.7"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit python cmake-utils ssl-cert java-pkg-2 java-utils-2

DESCRIPTION="Opensource Implementation of WS-Management Client"
HOMEPAGE="http://openwsman.github.io/"
SRC_URI="https://github.com/Openwsman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

RESTRICT="mirror"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cim debug examples +eventing ipv6 java mono pam perl python plugins ruby
ssl +server test"

RDEPEND="
	cim? ( dev-libs/sblim-sfcc )
	java? ( virtual/jdk )
	pam? ( virtual/pam )
	perl? ( dev-lang/perl )
	plugins? ( >=dev-lang/swig-2.0.5 )
	ruby? ( <dev-lang/ruby-2 )
	ssl? ( dev-libs/openssl )
	>=net-misc/curl-7.12[idn]
	dev-libs/libxml2[icu]
	"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cunit )
	"

# LIBC != glibc build fail - add block
pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare(){
	#Ruby gem builder does not like Unicode
	sed -e 's/Kämpf/Kaempf/' -i bindings/ruby/openwsman.gemspec.in
}

src_configure() {
	local mycmakeargs=(
		-DPACKAGE_ARCHITECTURE=${ARCH}
		$(cmake-utils_use_build cim LIBCIM)
		$(cmake-utils_use_build examples)
		$(cmake-utils_use_build java)
		$(cmake-utils_use_build mono CSHARP)
		$(cmake-utils_use_build perl)
		$(cmake-utils_use_build python)
		$(cmake-utils_use_build ruby)
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use_disable plugins)
		$(cmake-utils_use_disable server)
		$(cmake-utils_use_enable eventing)
		$(cmake-utils_use_enable ipv6)
		$(cmake-utils_use_use pam)
	)
	cmake-utils_src_configure
}

src_compile(){
	cmake-utils_src_compile -j1 #Upstream doesn't know about target	dependencies, sigh
}

src_install() {
	cmake-utils_src_install

	if use server; then
		newinitd "${FILESDIR}"/"${PN}"d.initd "${PN}"d
		newconfd "${FILESDIR}"/"${PN}"d.confd "${PN}"d
	fi
}

pkg_postinst() {
	if use ssl && [[ ! -f "${ROOT}"/etc/ssl/openwsman/servercert.pem \
		&& ! -f "${ROOT}"/etc/ssl/postfix/serverkey.pem ]] ; then
		SSL_ORGANIZATION="${SSL_ORGANIZATION:-Local OpenWSman Server}"
		install_cert /etc/openwsman/servercert
	fi
}
