# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-pkg-2 java-ant-2 eutils

MYPN="SweetHome3D"
MYP="${MYPN}-${PV}"
MN="3DModels"
MV="1.4"
MURI="mirror://sourceforge/project/${PN}/${MYPN}-models/${MN}-${MV}"
DESCRIPTION="Sweet Home 3D is a free interior design application"
HOMEPAGE="http://www.sweethome3d.com/"
SRC_URI="
	mirror://sourceforge/project/${PN}/${MYPN}-source/${MYP}-src/${MYP}-src.zip
	models? (
			 ${MURI}/${MN}-Contributions-${MV}.zip
			 ${MURI}/${MN}-LucaPresidente-${MV}.zip
			 ${MURI}/${MN}-Scopia-${MV}.zip
			 ${MURI}/${MN}-KatorLegaz-${MV}.zip
			 ${MURI}/${MN}-Reallusion-${MV}.zip
			 ${MURI}/${MN}-BlendSwap-CC-BY-${MV}.zip
			 ${MURI}/${MN}-BlendSwap-CC-0-${MV}.zip
			 ${MURI}/${MN}-Trees-${MV}.zip
			 )"

LICENSE=""
RESTRICT="mirror"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="models"

RDEPEND="
	dev-java/batik
	dev-java/freehep-graphics2d
	dev-java/freehep-graphicsio
	dev-java/freehep-graphicsio-svg
	dev-java/freehep-util
	dev-java/itext:0
	dev-java/jmf-bin
	dev-java/jnlp-api
	>=dev-java/sun-java3d-bin-1.5
	>=virtual/jre-1.6"
DEPEND="${RDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}/${MYP}-src"
EANT_BUILD_TARGET="application furniture textures help"

java_prepare() {
	edos2unix *.TXT
	cd lib || die
	rm {batik-svgpathparser-1.7,freehep-vectorgraphics-svg-2.1.1b}.jar || die
	rm {iText-2.1.7,j3dcore,j3dutils,jmf,vecmath}.jar || die
	java-pkg_jar-from freehep-graphicsio-svg,freehep-graphicsio,freehep-util
	java-pkg_jar-from freehep-graphics2d,itext,jmf-bin,batik-1.7,sun-java3d-bin
	java-pkg_jar-from jnlp-api
}

src_install() {
	dodoc *.TXT

	for jar in SweetHome3D Furniture Help Textures; do
		java-pkg_newjar build/${jar}.jar ${jar}.jar
	done
	java-pkg_newjar lib/Loader3DS1_2u.jar Loader3DS.jar
	java-pkg_newjar lib/sunflow-0.07.3i.jar sunflow.jar

	insinto ${DESTTREE}/share/${PN}
	doins ${WORKDIR}/*.sh3f
	
	java-pkg_dolauncher ${MYPN} --main com.eteks.sweethome3d.SweetHome3D \
		-Djava.library.path=$(java-config -i sun-java3d-bin) -Xmx1024m

	newicon deploy/${MYPN}Icon48x48.png ${MYPN}.png

	make_desktop_entry ${MYPN} "Sweet Home 3D" ${MYPN}
}

