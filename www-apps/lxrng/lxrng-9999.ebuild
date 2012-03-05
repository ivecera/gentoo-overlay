# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit perl-module webapp multilib eutils depend.apache git-2

DESCRIPTION="experimental fork of the LXR software by lxr.linux.no"
HOMEPAGE="http://lxr.linux.no/"
EGIT_REPO_URI="git://lxr.linux.no/git/lxrng.git"

LICENSE="GPL-2"
KEYWORDS=""
IUSE="pdf png"
WEBAPP_MANUAL_SLOT="yes"
SLOT="0"

RDEPEND="dev-perl/Search-Xapian
	dev-perl/DBD-Pg
	dev-perl/Cgi-Simple
	dev-perl/CGI-Ajax
	dev-perl/HTML-Parser
	dev-perl/Template-Toolkit
	dev-perl/PerlIO-gzip
	dev-perl/Term-ProgressBar
	dev-perl/Apache-Reload
	dev-perl/Devel-Size
	dev-util/ctags"
#	png? ( media-gfx/inkscape )
#	pdf? ( dev-texlive/texlive-latexrecommended )"

DEPEND="${RDEPEND}"

need_apache2

S="${WORKDIR}/${PN}"

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	perlinfo
	webapp_src_preinst

	insinto "${VENDOR_LIB}"
	doins -r lib/LXRng lib/LXRng.pm lib/Subst || die

	dodoc INSTALL CREDITS

	exeinto "${MY_HTDOCSDIR}"
	doexe lxr-db-admin lxr-genxref lxr-stat || die
	insinto "${MY_HTDOCSDIR}"
	doins -r webroot tmpl || die
	doins apache2-site.conf-dist-cgi apache2-site.conf-dist-mod_perl lxrng.conf-dist

	webapp_configfile "${MY_HTDOCSDIR}"/apache2-site.conf-dist-cgi "${MY_HTDOCSDIR}"/apache2-site.conf-dist-mod_perl "${MY_HTDOCSDIR}"/lxrng.conf-dist
	#webapp_sqlscript postgresql initdb-postgres
	#webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	#webapp_hook_script "${FILESDIR}"/reconfig
	webapp_src_install
}
