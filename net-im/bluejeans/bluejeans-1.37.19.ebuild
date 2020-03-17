# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit rpm xdg

DESCRIPTION="Online meetings, video conferencing, and screen sharing for teams of any size"
HOMEPAGE="https://www.bluejeans.com"
SRC_URI="https://swdl.bluejeans.com/desktop/linux/1.37/${PV}/bluejeans-${PV}.x86_64.rpm"

LICENSE="BlueJeans"
SLOT="0"
KEYWORDS="~amd64 ~x86"
QA_PRESTRIPPED="opt/bluejeans/bluejeans-bin opt/bluejeans/nwsnapshot"
IUSE=""

RDEPEND="sys-libs/libudev-compat"

S="${WORKDIR}"

src_unpack() {
	rpm_src_unpack ${A}
}

src_install() {
	cp -R "${S}/"* "${D}/" || die "Install failed!"

	local res
	for res in 16 24 32 256; do
		newicon -s ${res} opt/${PN}/icons/hicolor/${res}x${res}/apps/${PN}.png ${PN}.png
	done

	fperms +x /opt/${PN}/${PN}
	fperms +x /opt/${PN}/${PN}-bin

	dosym /opt/${PN}/${PN} /opt/bin/${PN}
	dosym /opt/${PN}/${PN}-bin /opt/bin/${PN}-bin
	dosym /usr/lib64/libudev.so.0 /opt/${PN}/libudev.so.0

	sed -i -e '/^Version=/d' opt/${PN}/${PN}.desktop
	domenu opt/${PN}/${PN}.desktop
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
