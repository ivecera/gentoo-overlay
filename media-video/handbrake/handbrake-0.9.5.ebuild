# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2-utils eutils autotools

MY_PN="HandBrake"
S="${WORKDIR}/${MY_PN}-${PV}"

DESCRIPTION="Open-source DVD to MPEG-4 converter"
HOMEPAGE="http://handbrake.fr/"
CONTRIB_URIS="
http://download.m0k.org/handbrake/contrib/a52dec-0.7.4.tar.gz
-> hb-a52dec-0.7.4.tar.gz
http://download.m0k.org/handbrake/contrib/faac-1.28.tar.gz
-> hb-faac-1.28.tar.gz
http://download.m0k.org/handbrake/contrib/faad2-2.7.tar.gz
-> hb-faad2-2.7.tar.gz
http://download.m0k.org/handbrake/contrib/ffmpeg-r25689.tar.bz2
-> hb-ffmpeg-r25689.tar.bz2
http://download.m0k.org/handbrake/contrib/fontconfig-2.8.0.tar.gz
-> hb-fontconfig-2.8.0.tar.gz
http://download.m0k.org/handbrake/contrib/freetype-2.3.9.tar.gz
-> hb-freetype-2.3.9.tar.gz
http://download.m0k.org/handbrake/contrib/lame-3.98.tar.gz
-> hb-lame-3.98.tar.gz
http://download.m0k.org/handbrake/contrib/libass-0.9.9.tar.bz2
-> hb-libass-0.9.9.tar.bz2
http://download.m0k.org/handbrake/contrib/libdca-r81-strapped.tar.gz
-> hb-libdca-r81-strapped.tar.gz
http://download.m0k.org/handbrake/contrib/libdvdread-svn1168.tar.gz
-> hb-libdvdread-svn1168.tar.gz
http://download.m0k.org/handbrake/contrib/libdvdnav-svn1168.tar.gz
-> hb-libdvdnav-svn1168.tar.gz
http://download.m0k.org/handbrake/contrib/libbluray-0.0.1-pre-16-g1aab213.tar.gz
-> hb-libbluray-0.0.1-pre-16-g1aab213.tar.gz
http://download.m0k.org/handbrake/contrib/libmkv-0.6.4.1-0-ga80e593.tar.bz2
-> hb-libmkv-0.6.4.1-0-ga80e593.tar.bz2
http://download.m0k.org/handbrake/contrib/libogg-1.1.3.tar.gz
-> hb-libogg-1.1.3.tar.gz
http://download.m0k.org/handbrake/contrib/libsamplerate-0.1.4.tar.gz
-> hb-libsamplerate-0.1.4.tar.gz
http://download.m0k.org/handbrake/contrib/libtheora-1.1.0.tar.bz2
-> hb-libtheora-1.1.0.tar.bz2
http://download.m0k.org/handbrake/contrib/libvorbis-aotuv_b5.tar.gz
-> hb-libvorbis-aotuv_b5.tar.gz
http://download.m0k.org/handbrake/contrib/libxml2-2.7.7.tar.gz
-> hb-libxml2-2.7.7.tar.gz
http://download.m0k.org/handbrake/contrib/mp4v2-trunk-r355.tar.bz2
-> hb-mp4v2-trunk-r355.tar.bz2
http://download.m0k.org/handbrake/contrib/mpeg2dec-0.5.1.tar.gz
-> hb-mpeg2dec-0.5.1.tar.gz
http://download.handbrake.fr/handbrake/contrib/x264-r1834-a51816a.tar.gz
-> hb-x264-r1834-a51816a.tar.gz"
SRC_URI="http://handbrake.fr/rotation.php?file=${MY_PN}-${PV}.tar.bz2
		-> ${MY_PN}-${PV}.tar.bz2
		${CONTRIB_URIS}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

IUSE="css doc gtk"
RDEPEND="sys-libs/zlib
	css? ( media-libs/libdvdcss )
	gtk? (	>=x11-libs/gtk+-2.8
			dev-libs/glib
			dev-libs/dbus-glib
			x11-libs/libnotify
			media-libs/gstreamer
			media-libs/gst-plugins-base
			>=sys-fs/udev-147[extras]
	)"
DEPEND="=sys-devel/automake-1.10*
	=sys-devel/automake-1.4*
	=sys-devel/automake-1.9*
	dev-lang/yasm
	>=dev-lang/python-2.4.6
	|| ( >=net-misc/wget-1.11.4 >=net-misc/curl-7.19.4 )
	$RDEPEND"

src_unpack() {
	unpack "${MY_PN}-${PV}.tar.bz2"

	mkdir "${S}/download"
	for a in ${A}; do
		case ${a} in
			${MY_PN}-${PV}.tar.bz2)
				;;
			*)
				einfo "Copying dependecy - ${a##hb-}"
				cp -f "${DISTDIR}/${a}" "${S}/download/${a##hb-}"
				;;
		esac
	done
}

src_prepare() {
	epatch "${FILESDIR}/${PV}-backport-lib-fixes.patch"
	cd gtk
	eautoreconf
}

src_configure() {
	local myconf=""

	! use gtk && myconf="${myconf} --disable-gtk"

	./configure --force --prefix=/usr --disable-gtk-update-checks ${myconf} || die "configure failed"
}

src_compile() {
	WANT_AUTOMAKE=1.9 emake -C build || die "failed compiling ${PN}"
}

src_install() {
	emake -C build DESTDIR="${D}" install || die "failed installing ${PN}"

	if use doc; then
		emake -C build doc
			dodoc AUTHORS CREDITS NEWS THANKS \
				build/doc/articles/txt/* || die "docs failed"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
