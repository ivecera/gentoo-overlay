# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

MODULE_AUTHOR=OLLY
inherit perl-module

DESCRIPTION="a perl-specific system for writing Asynchronous web applications"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build
	dev-libs/xapian
	test? ( virtual/perl-Test-Simple
		dev-perl/Cgi-Simple
		dev-perl/Test-Pod )"

SRC_TEST="do"
