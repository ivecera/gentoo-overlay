# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils java-pkg-2

DESCRIPTION="yEd Graph Editor - High-quality diagrams made easy"
HOMEPAGE="http://www.yworks.com/en/products_yed_about.html"
SRC_URI="http://www.yworks.com/resources/yed/demo/yEd-${PV}.zip"

LICENSE="yEd"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND=">=virtual/jre-1.8"
DEPEND="
	app-arch/unzip
	${RDEPEND}"

src_install() {
	cd "${S}"
	java-pkg_dojar lib/*
	java-pkg_dojar ${PN}.jar
	java-pkg_dolauncher yed --jar ${PN}.jar
	doicon icons/yicon32.png
	make_desktop_entry ${PN} "yEd Graph Editor" yicon32 "Graphics;2DGraphics"
	dodoc license.html
}

