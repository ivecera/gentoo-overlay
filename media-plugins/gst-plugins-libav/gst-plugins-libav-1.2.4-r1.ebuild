# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils flag-o-matic multilib-minimal

MY_PN="gst-libav"
DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="http://gstreamer.freedesktop.org/src/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+orc libav10"

RDEPEND="
	>=media-libs/gstreamer-1.2.3:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.2.3:1.0[${MULTILIB_USEDEP}]
	!libav10? ( !!>=media-video/libav-10[${MULTILIB_USEDEP}] )
	libav10? ( !!<media-video/libav-10[${MULTILIB_USEDEP}] )
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.12
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	# compatibility with recent releases 
	# TODO: likely apply them with libav-10 when it's out but there will
	# probably be an upstream gst-libav release compatible at that time.
	if has_version '>=media-video/ffmpeg-2.0' ; then
		sed -i -e 's/ CODEC_ID/ AV_CODEC_ID/g' \
			   -e 's/ CodecID/ AVCodecID/g' \
			   ext/libav/*.{c,h} || die
		epatch "${FILESDIR}/${PN}-1.2.4-ffmpeg2.patch"
		epatch "${FILESDIR}/${PN}-1.2.4-fix-memory-leak.patch" #494282
	fi
	if use libav10; then
		# libav10 patches
		epatch "${FILESDIR}/${P}-libav10-01-codecid-avcodecid.patch"
		epatch "${FILESDIR}/${P}-libav10-02-avenc.patch"
		epatch "${FILESDIR}/${P}-libav10-03-no-r-frame-rate-field.patch"
		epatch "${FILESDIR}/${P}-libav10-04-no_AVCODEC_MAX_AUDIO_FRAME_SIZE.patch"
		epatch "${FILESDIR}/${P}-libav10-05-new_config_interface.patch"
		epatch "${FILESDIR}/${P}-libav10-06-av_encode_video.patch"
	fi
}

multilib_src_configure() {
	GST_PLUGINS_BUILD=""
	# always use system ffmpeg/libav if possible
	ECONF_SOURCE=${S} \
	econf \
		--disable-maintainer-mode \
		--with-package-name="Gentoo GStreamer ebuild" \
		--with-package-origin="http://www.gentoo.org" \
		--disable-fatal-warnings \
		--with-system-libav \
		$(use_enable orc)
}

multilib_src_compile() {
	# Don't build with -Werror
	emake ERROR_CFLAGS=
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --modules
}
