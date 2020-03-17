# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit rpm xdg

DESCRIPTION="Online meetings, video conferencing, and screen sharing for teams of any size"
HOMEPAGE="https://www.bluejeans.com"
SRC_URI="https://swdl.bluejeans.com/desktop-app/linux/${PV}/BlueJeans.rpm -> ${P}.rpm"

LICENSE="BlueJeans"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

QA_PRESTRIPPED="
	opt/BlueJeans/resources/app.asar.unpacked/node_modules/fiber-wrapper-node/dependencies/build/fiberclient/lib/libdvclient.so
	opt/BlueJeans/resources/app.asar.unpacked/node_modules/fiber-wrapper-node/dependencies/build/fiberclient/lib/libfiber.so.2.0.0
	opt/BlueJeans/libffmpeg.so
	opt/BlueJeans/libEGL.so
	opt/BlueJeans/bluejeans-v2
	opt/BlueJeans/libGLESv2.so"

S="${WORKDIR}"

src_unpack() {
	rpm_src_unpack ${A}
}

src_install() {
	cp -R "${S}/"* "${D}/" || die "Install failed!"

	fperms +x /opt/BlueJeans/${PN}-v2
	domenu usr/share/applications/bluejeans-v2.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
