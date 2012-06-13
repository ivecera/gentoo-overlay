# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils gnome2

DESCRIPTION="Kerberos 5 authentication dialog"
HOMEPAGE="https://honk.sigxcpu.org/piki/projects/krb5-auth-dialog/"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/krb5-auth-dialog/3.2/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="caps networkmanager pam"

RDEPEND="virtual/krb5
		>=dev-libs/dbus-glib-0.80
		>=dev-libs/glib-2.28
		>=gnome-base/gconf-2.31
		>=x11-libs/gtk+-3.0
		>=x11-libs/libnotify-0.7
		caps? ( sys-libs/libcap )
		networkmanager? ( net-misc/networkmanager )
		pam? ( sys-libs/pam )"
DEPEND="${RDEPEND}"

pkg_setup() {
	G2CONF="${G2CONF}
			$(use_with caps libcap)
			$(use_enable networkmanager network-manager)
			$(use_with pam)"
}
