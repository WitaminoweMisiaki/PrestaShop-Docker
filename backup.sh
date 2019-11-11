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
	git push origin HEAD:$localManifestBranch --force
	cd ..
}


function make_backup() {
    local dir="$1"
	local dbbackupname="db_$(date +%Y-%m-%d-%H:%M).tar.gz"
	local psbackupname="ps_$(date +%Y-%m-%d-%H:%M).tar.gz"
	mkdir -p "$dir"
	cd mariadb
	tar -czf "${dir}/${dbbackupname}" .
	cd ../prestashop
	tar -czf "${dir}/${psbackupname}" .
 
    
    rm -f "${dir}/mariadb.tar.gz"
    rm -f "${dir}/prestashop.tar.gz"

    ln -s "${dir}/${dbbackupname}" "${dir}/mariadb.tar.gz"
    ln -s "${dir}/${psbackupname}" "${dir}/prestashop.tar.gz"

	cd ..
}

backup_dir=$2
docker-compose -f $1 down || true

make_backup $backup_dir

docker-compose -f $1 up -d --force-recreate --remove-orphans || true
