# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )

inherit distutils-r1 git-r3

DESCRIPTION="Brings more robust operations"
HOMEPAGE=""
EGIT_REPO_URI="https://github.com/mirrorshq/robust_layer.git"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

src_install() {
        distutils-r1_src_install

	dodir /usr/libexec/robust_layer
	cp libexec/* ${D}/usr/libexec/robust_layer
	chmod 755 ${D}/usr/libexec/robust_layer/*
}
