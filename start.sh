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
            git pull --recurse-submodules
        )
    else
        git clone --recursive git@github.com:WitaminoweMisiaki/"$repo" "$dir" -b "$localManifestBranch"
        git-crypt unlock || true
    fi
}

function decompress_backup() {
    rm -Rf mariadb
    rm -Rf prestashop
    mkdir -p mariadb
    mkdir -p prestashop
    tar -xf ./backup/mariadb.tar.gz -C ./mariadb
    tar -xf ./backup/prestashop.tar.gz -C ./prestashop
}


# clone_or_checkout $PWD PrestaShop-Docker


decompress_backup

docker-compose down || true
docker-compose up -d --force-recreate --remove-orphans
docker-compose logs --follow
