# Prestashop Docker

## What you need

1. Docker, docker-compose
2. Configured git crypt
3. Configured git SSH keys for backup

=======
## Local vs Production config

In all commands that have [DOCKER FILE] replace [DOCKER FILE] with local.yml for local testing and production.yml on production server.

## Backup dir
We don't store backup on github now. With [BACKUP DIR] you can specify dir where you store backups.

## How to start

```
git clone git@github.com:WitaminoweMisiaki/PrestaShop-Docker.git prestashop
cd prestashop
git-crypt unlock
sudo -E ./start.sh [DOCKER FILE] [BACKUP DIR]
```

## How to backup

```
sudo -E ./backup.sh [DOCKER FILE] [BACKUP DIR]
```

