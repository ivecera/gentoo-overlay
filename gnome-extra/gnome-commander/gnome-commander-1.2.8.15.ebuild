# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit gnome2 flag-o-matic

DESCRIPTION="A full featured, dual-pane file manager for Gnome2"
HOMEPAGE="http://www.nongnu.org/gcmd/"

SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/1.2/${P}.tar.xz";

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="chm doc exif +gsf pdf python taglib"
RESTRICT="mirror"

USE_DESC="
	   chm: add support for CHM
	  exif: add support for Exif and IPTC
	   gsf: add support for OLE, OLE2 and ODF
	taglib: add support for ID3, Vorbis, FLAC and APE
	   pdf: add support for pdf
	python: add support for python plugins"

RDEPEND="app-text/gnome-doc-utils
        >=dev-libs/glib-2.6.0
        >=gnome-base/gnome-vfs-2.0.0
        >=gnome-base/libgnome-2.0.0
        >=gnome-base/libgnomeui-2.4.0
		>=x11-libs/gtk+-2.8.0
        || ( app-admin/gamin app-admin/fam )
		chm?	( dev-libs/chmlib )
        exif?   ( >=media-gfx/exiv2-0.14 )
        gsf?    ( >=gnome-extra/libgsf-1.12.0 )
        taglib? ( >=media-libs/taglib-1.4 )
		pdf?	( app-text/poppler )
        python? ( >=dev-lang/python-2.4
                  >=dev-python/gnome-vfs-python-2.0.0 )"

DEPEND="${RDEPEND}
        >=dev-util/intltool-0.35.0
        dev-util/pkgconfig"

DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable doc scrollkeeper)
		$(use_enable python)
		$(use_with chm libchm)
		$(use_with exif libexiv2)
		$(use_with gsf libgsf)
		$(use_with taglib taglib)
		$(use_with pdf poppler)"
	filter-ldflags -Wl,--as-needed
}
