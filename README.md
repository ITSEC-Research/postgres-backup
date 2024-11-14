# PostgreSQL Backup Script

This script was used to backup all schema/database postgresql version 15 to the GCP, if you want to dump older version you need to change the postgres-client-15 to the version what you want on Dockerfile

# How to use

For running on your local device use docker, just run `docker compose up` it will automatically build local docker images

If you are running on kubernetes, just apply the manifest `kubectl -n namespace -f kubernetes-postgres-backup-k8s.yml apply`