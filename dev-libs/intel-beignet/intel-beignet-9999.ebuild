# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 cmake-utils multilib-minimal
CMAKE_BUILD_TYPE="Release"

DESCRIPTION="The Beignet GPGPU System for Intel Ivybridge GPUs"
HOMEPAGE="http://wiki.freedesktop.org/www/Software/Beignet/"

LICENSE="GPL-2"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://anongit.freedesktop.org/beignet"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://01.org/sites/default/files/${P/intel-/}-source.tar.gz -> ${P}.tar.gz"
	S=${WORKDIR}/Beignet-${PV}-Source
fi

DEPEND=">=sys-devel/gcc-4.6
	${PYTHON_DEPS}"
RDEPEND="app-eselect/eselect-opencl
	media-libs/mesa[${MULTILIB_USEDEP}]
	sys-devel/clang[${MULTILIB_USEDEP}]
	>=sys-devel/llvm-3.5[${MULTILIB_USEDEP}]
	x11-libs/libdrm[video_cards_intel,${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]"

pkg_setup() {
	python_setup
}
IBEIGNET_DIR=/usr/$(get_libdir)/OpenCL/vendors/intel-beignet

src_prepare() {
	# disable tests for now
	sed -i "s/ADD_SUBDIRECTORY(utests)/#ADD_SUBDIRECTORY(utests)/" \
		CMakeLists.txt || die "sed failed"

	# disable debian multiarch
	#epatch "${FILESDIR}/no-debian-multiarch-${PV}.patch"

	# respect compile flags
	epatch "${FILESDIR}/respect-flags-${PV}.patch"

	epatch "${FILESDIR}/tr.patch"

	echo "${IBEIGNET_DIR}/lib/beignet/libcl.so" > intelbeignet.icd
	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=( -DCMAKE_INSTALL_PREFIX="${IBEIGNET_DIR}/" )

	multilib_is_native_abi || mycmakeargs+=(
		-DLLVM_CONFIG_EXECUTABLE="${EPREFIX}/usr/bin/llvm-config.${ABI}"
		-DCMAKE_C_FLAGS="$(get_abi_var CFLAGS)"
		-DCMAKE_CXX_FLAGS="$(get_abi_var CXXFLAGS)"
	)

	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install

	cd ${S}
	#insinto /etc/OpenCL/vendors/
	#doins intelbeignet.icd

	multilib_is_native_abi && {
		dodoc -r docs
	}

	dosym lib/beignet/libcl.so "${IBEIGNET_DIR}"/libOpenCL.so.1
	dosym lib/beignet/libcl.so "${IBEIGNET_DIR}"/libOpenCL.so
	dosym lib/beignet/libcl.so "${IBEIGNET_DIR}"/libcl.so.1
	dosym lib/beignet/libcl.so "${IBEIGNET_DIR}"/libcl.so
}
