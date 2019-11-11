# Prestashop Docker

## What you need

1. Docker, docker-compose
2. Configured git crypt
3. Configured git SSH keys for backup

## How to start

```
git clone git@github.com:WitaminoweMisiaki/PrestaShop-Docker.git --recurse-submodules prestashop
cd prestashop
git-crypt unlock
./start.sh
```

## How to backup

```
sudo -E ./backup.sh
```

