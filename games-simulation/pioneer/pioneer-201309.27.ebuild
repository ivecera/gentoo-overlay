# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils games autotools-utils

DESCRIPTION="Pioneer is a space adventure game set in the Milky Way galaxy at the turn of the 31st century."
HOMEPAGE="http://pioneerspacesim.net/"
SRC_URI="https://github.com/pioneerspacesim/${PN}/archive/${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug external-lua"

RDEPEND="
	dev-libs/libsigc++:2
	>=media-gfx/assimp-3.0
	media-libs/freetype:2
	>=media-libs/glew-1.5
	media-libs/libpng
	media-libs/libvorbis
	media-libs/sdl-image
	virtual/opengl
	external-lua? ( >=dev-lang/lua-5.2 )
"
DEPEND="${RDEPEND}"

AUTOTOOLS_AUTORECONF=1

DOCS=( AUTHORS.txt Changelog.txt Quickstart.txt README.txt )

src_prepare() {
	rm -rf contrib/glew contrib/json
	sed -i -e 's/glew//' -e 's/json//' contrib/Makefile.am
	sed -i -e '/contrib\/json\/Makefile/d' -e '/contrib\/glew\/Makefile/d' \
		configure.ac
	sed -i -e 's|../contrib/glew/libglew.a|-lGLEW|' \
		-e 's|../contrib/json/libjson.a|-ljsoncpp|' \
		src/Makefile.am
	autotools-utils_src_prepare

	sed -i -e 's|"glew/glew.h"|<GL/glew.h>|' \
		src/libs.h src/graphics/TextureGL.h
}

src_configure() {
	local myeconfargs=(
		--bindir="${GAMES_BINDIR}"
		$(use_enable debug)
		$(use_with external-lua external-liblua)
	)
	PIONEER_DATA_DIR="${GAMES_DATADIR}/${PN}" autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	for f in 16 22 24 32 48 64 128 256; do
		newicon -s $f application-icon/pngs/${PN}-${f}x${f}.png ${PN}.png
	done
	make_desktop_entry ${PN} "Pioneer Space Simulator" ${PN}
	prepgamesdirs
}
