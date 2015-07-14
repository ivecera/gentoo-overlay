# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="4"

inherit eutils

if [[ ${PV} == "9999" ]] ; then
	ESVN_REPO_URI="https://sdcc.svn.sourceforge.net/svnroot/sdcc/trunk/sdcc"
	inherit subversion autotools
else
	SRC_URI="mirror://sourceforge/sdcc/${PN}-src-${PV}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

DESCRIPTION="Small device C compiler (for various microprocessors)"
HOMEPAGE="http://sdcc.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+boehm-gc doc"
RESTRICT="binchecks mirror strip"

RDEPEND="sys-libs/ncurses
	sys-libs/readline
	>=dev-embedded/gputils-0.13.7
	boehm-gc? ( dev-libs/boehm-gc )
	!dev-embedded/sdcc-svn"
DEPEND="${RDEPEND}
	doc? (	>=app-office/lyx-1.3.4
			dev-tex/latex2html )"

src_prepare() {
	# Fix conflicting variable names between Gentoo and sdcc
	find \
		'(' -name 'Makefile*.in' -o -name configure ')' \
		-exec sed -r -i \
			-e 's:\<(PORTDIR|ARCH)\>:SDCC\1:g' \
			{} + || die

	epatch "${FILESDIR}"/${P}-build.patch

	# Build all doc types
	sed -i -e 's/#all/all/' doc/Makefile.in || die
	sed -i -e '/^all.*pdf$/d' doc/Makefile.in || die

	# We'll install doc manually
	sed -i -e '/SDCC_DOC/d' Makefile.in || die
	sed -i -e 's/ doc//' sim/ucsim/packages_in.mk || die

	[[ ${PV} == "9999" ]] && eautoreconf

	# workaround parallel build issues with lyx
	mkdir -p "${HOME}"/.lyx
}

src_configure() {
	ac_cv_prog_STRIP=true \
	ac_cv_prog_PDFOPT=cp \
	econf \
		$(use_enable boehm-gc libgc) \
		$(use_enable doc)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc doc/*.txt doc/*.pdf
	docinto sdas
	dodoc sdas/doc/*.txt

	find "${D}" -name .deps -exec rm -rf {} +

	if use doc ; then
		cd doc/sdccman.html
		docinto ""
		dohtml -r *.html *.png *.css
	fi

	rm -f ${D}/usr/lib*/libiberty.a

	# a bunch of archives (*.a) are built & installed by gputils
	# for PIC processors, but they do not work with standard `ar`
	# & `scanelf` utils and they're not for the host.
	env RESTRICT="" prepstrip "${D%/}"/usr/bin
}
