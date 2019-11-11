#!/bin/bash
localManifestBranch=$(git branch | grep \* | cut -d ' ' -f2)
set -e

function commit_and_push() {
	local dir="$1"
	cd "$dir" 
	git checkout -b $localManifestBranch 2>/dev/null  || true
	backupString="Backup $(date +%Y-%m-%d-%H:%M)"
	find . -name '.DS_Store' -type f -delete && git add -A
	git commit -m "${backupString}"
	git push --force
}


function make_backup() {
	local dbbackupname="db_$(date +%Y-%m-%d-%H:%M).tar.gz"
	local psbackupname="ps_$(date +%Y-%m-%d-%H:%M).tar.gz"
	mkdir -p backup
	cd mariadb
	tar -czf "../backup/${dbbackupname}" .
	cd ../prestashop
	tar -czf "../backup/${psbackupname}" .


	cd ../backup

	rm -f mariadb.tar.gz
	rm -f prestashop.tar.gz

	ln -s "${dbbackupname}" mariadb.tar.gz
	ln -s "${psbackupname}" prestashop.tar.gz

	cd ..
}

docker-compose down || true

make_backup
commit_and_push backup

docker-compose up -d --force-recreate --remove-orphans || true
