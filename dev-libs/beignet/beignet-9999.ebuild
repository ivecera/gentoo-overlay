# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
CMAKE_BUILD_TYPE="Release"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit python-single-r1 cmake-utils git-r3 multilib-minimal

DESCRIPTION="The Beignet GPGPU System for Intel Ivybridge GPUs"
HOMEPAGE="http://wiki.freedesktop.org/www/Software/Beignet/"

# we cannot use the snapshots as the checksum changes for every download
EGIT_REPO_URI="git://anongit.freedesktop.org/beignet"

LICENSE="LGPL-2"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	EGIT_COMMIT="Release_v${PV}"
fi

RDEPENDS="
	app-admin/eselect-opencl
	media-libs/mesa[${MULTILIB_USEDEP}]
	>=sys-devel/clang-3.1[${MULTILIB_USEDEP}]
	>=sys-devel/llvm-3.1[${MULTILIB_USEDEP}]
	x11-libs/libdrm[video_cards_intel,${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	"
DEPENDS="${RDEPEND} ${PYTHON_DEPS}"

src_prepare() {
	cmake-utils_src_prepare

	epatch "${FILESDIR}/${PN}-respect-flags.patch"
	epatch "${FILESDIR}/${PN}-opencl.patch"
	epatch "${FILESDIR}/${PN}-tr.patch"
}

multilib_src_configure() {
	local mycmakeargs=(
		-DLIB_INSTALL_DIR="/usr/$(get_libdir)/OpenCL/vendors"
	)

	multilib_is_native_abi || mycmakeargs+=(
		-DLLVM_CONFIG_EXECUTABLE="${EPREFIX}/usr/bin/llvm-config.${ABI}"
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install

	cd ${D}
	insinto /usr/$(get_libdir)/OpenCL/vendors/${PN}/include/CL
	doins usr/include/CL/*
	rm -rf usr/include

	multilib_is_native_abi && {
		cd ${S}
		dodoc -r docs
	}
#	insinto /etc/OpenCL/vendors/
#	doins intelbeignet.icd
}
