# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit distutils-r1 git-r3

EGIT_REPO_URI="https://github.com/mirrorshq/mirrors.git"
SRC_URI=""

DESCRIPTION="--fixme"
KEYWORDS="-* amd64 x86"

LICENSE="GPL-3"
SLOT="0"

ALL_STORAGE=( mariadb mongodb neo4j )
ALL_STORAGE_EXP=( "${ALL_STORAGE[@]/#/mirrors_storage_}" )
ALL_ADVERTISERS=( httpdir ftp rsync git klaus mediawiki kiwix )
ALL_ADVERTISERS_EXP=( "${ALL_ADVERTISERS[@]/#/mirrors_advertiser_}" )
IUSE="pservers zeroconf ${ALL_STORAGE_EXP[*]} ${ALL_ADVERTISERS_EXP[*]}"

RDEPEND="acct-user/mirrors
         acct-group/mirrors
         app-admin/apache-tools
         dev-python/croniter
         dev-python/asyncio-glib
         dev-python/aiohttp
         dev-python/jinja
         dev-python/aiohttp-jinja2
         dev-python/dbus-python
         dev-python/python-prctl
         dev-python/psutil
         pservers? ( net-misc/pservers )
         zeroconf? ( net-dns/avahi )"
RDEPEND="${RDEPEND}
         mirrors_storage_mariadb? ( dev-db/mariadb
                                    dev-python/mariadb-connector-python
                                    dev-python/sqlparse )
         mirrors_storage_mongodb? ( dev-db/mongodb )
         mirrors_storage_neo4j? ( dev-db/neo4j-community )"
RDEPEND="${RDEPEND}
         mirrors_advertiser_httpdir? ( www-servers/apache
                                       dev-python/atomicwrites )
         mirrors_advertiser_ftp? ( dev-python/pyftpdlib
                                   dev-python/atomicwrites )
         mirrors_advertiser_rsync? ( dev-python/atomicwrites )
         mirrors_advertiser_git? ( dev-vcs/git )
         mirrors_advertiser_klaus? ( www-servers/apache
                                     www-apache/mod_wsgi
                                     www-apps/klaus
                                     dev-python/atomicwrites )
         mirrors_advertiser_mediawiki? ( www-apps/mediawiki[mysql] )
         mirrors_advertiser_kiwix? ( www-misc/kiwix-tools )"

DEPEND=""


# install mirrors program by make
# install mirrors python module by distutils

src_prepare() {
	eapply_user
	if ! use pservers ; then
		sed -i -e "s/self.pserversSupport = .*/self.pserversSupport = False/g" "${WORKDIR}/${P}/lib/mc_param.py"
	fi
	if ! use zeroconf ; then
		sed -i -e "s/self.avahiSupport = .*/self.avahiSupport = False/g" "${WORKDIR}/${P}/lib/mc_param.py"
	fi
	for s in "${ALL_STORAGE[@]}" ; do
		if ! use mirrors_storage_$s ; then
			rm -rf "${WORKDIR}/${P}/lib/storage/${s}"
		fi
	done
	for s in "${ALL_ADVERTISERS[@]}" ; do
		if ! use mirrors_advertiser_$s ; then
			rm -rf "${WORKDIR}/${P}/lib/advertiser/${s}"
		fi
	done

	distutils-r1_src_prepare
}

src_compile() {
	emake || die "emake failed"
	distutils-r1_src_compile
}

src_install() {
	emake DESTDIR="${D}" install
	distutils-r1_src_install
}

pkg_extra_files() {
	echo "/etc/mirrors"
	echo "/etc/mirrors/***"

	echo "/var/lib/mirrors"

	echo "/var/cache/mirrors"

	echo "/var/log/mirrors/***"
#	echo "/var/log/mirrors"
#	echo "/var/log/mirrors/mirrors.out"
#	echo "/var/log/mirrors/main-httpd.log"
#	for s in "${ALL_ADVERTISERS[@]}"; do
#		if ! use mirrors_advertiser_$s ; then
#			echo "/var/log/mirrors/advertiser-${s}/***"
#		fi
#	done
}
