#!/bin/bash
localManifestBranch=$(git branch | grep \* | cut -d ' ' -f2)
set -e

function clone_or_checkout() {
    local dir="$1"
    local repo="$2"

    if [[ -d "$dir" ]];then
        (
            cd "$dir"
            git fetch
            git reset --hard
            git pull
        )
    else
        git clone git@github.com:WitaminoweMisiaki/"$repo" "$dir" -b "$localManifestBranch"
        git-crypt unlock || true
    fi
}

function decompress_backup() {
    local dir="$1"
    rm -Rf mariadb
    rm -Rf prestashop
    mkdir -p mariadb
    mkdir -p prestashop
    tar -xf "${dir}/mariadb.tar.gz" -C ./mariadb
    tar -xf "${dir}/prestashop.tar.gz" -C ./prestashop
}


clone_or_checkout $PWD PrestaShop-Docker


decompress_backup $2

docker-compose -f $1 down || true
docker-compose -f $1 up -d --force-recreate --remove-orphans
docker-compose -f $1 logs --follow
