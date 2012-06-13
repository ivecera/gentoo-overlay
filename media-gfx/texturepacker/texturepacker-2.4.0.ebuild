# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils fdo-mime gnome2-utils unpacker

DESCRIPTION="Sprite sheet creator and image optimizer"
HOMEPAGE="http://www.texturepacker.com/"
SRC_URI="http://www.codeandweb.com/download/${PN}/${PV}/TexturePacker-${PV}-ubuntu64.deb"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RESTRICT="mirror"
QA_PREBUILT="*"

RDEPEND="
	>=x11-libs/qt-core-4.7.2
	>=x11-libs/qt-gui-4.7.2
	>=x11-libs/qt-opengl-4.7.2
	>=x11-libs/qt-webkit-4.7.2"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_install() {
	insinto /usr/share/mime/packages
	doins usr/share/mime/packages/CodeAndWeb-TexturePacker.xml
	dobin usr/bin/TexturePacker
	dolib usr/lib/*
	doicon usr/share/pixmaps/texturepacker.png
	for sz in 16 24 32 48 64 128 256; do
		doicon -c mimetypes -s $sz \
			usr/share/icons/hicolor/${sz}x${sz}/mimetypes/*
	done
	insinto /usr/share/applications
	doins usr/share/applications/texturepacker.desktop
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
