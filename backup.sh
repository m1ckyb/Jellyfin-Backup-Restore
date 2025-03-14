#! /bin/bash

# Import the .env vars
if [ ! -e .env ]; then
    echo >&2 'Please configure the .env file'
    exit 1
fi
set -a
. ./.env
set +a

# Generate the backup directory name.
TIMESTAMP=$(date +%Y.%m.%d.%H.%M.%S)
BACKUP_DIR="${JELLYFIN_VERSION}-${TIMESTAMP}"

mkdir -p ${BACKUPS}/${BACKUP_DIR}
cd ${BACKUPS}/${BACKUP_DIR}


# Stop Jellyfin
systemctl stop jellyfin

# Backup Jellyfin config
if [ ! -z ${JELLYFIN_CONFIG_DIR} ]; then
    echo "backing up Jellyfin config to ${BACKUPS}/${BACKUP_DIR}/${CONFIG_TAR}"
    tar cf - ${JELLYFIN_CONFIG_DIR}  -P | pv -s $(du -sb ${JELLYFIN_CONFIG_DIR} | awk '{print $1}') | gzip > ${CONFIG_TAR}
    #tar -zcf ${CONFIG_TAR} -C ${JELLYFIN_CONFIG_DIR} .
fi

# Backup Jellyfin media.
if [ ! -z ${JELLYFIN_MEDIA_DIR} ]; then
    echo "backup up Jellyfin media to ${BACKUPS}/${BACKUP_DIR}/${MEDIA_TAR}"
    tar cf - ${JELLYFIN_MEDIA_DIR}  -P | pv -s $(du -sb ${JELLYFIN_MEDIA_DIR} | awk '{print $1}') | gzip > ${MEDIA_TAR}    
    #tar -zcf ${MEDIA_TAR} -C ${JELLYFIN_MEDIA_DIR} .
fi

# Backup Jellyfin data.
if [ ! -z ${JELLYFIN_DATA_DIR} ]; then
    echo "backup up Jellyfin data to ${BACKUPS}/${BACKUP_DIR}/${DATA_TAR}"
    tar cf - ${JELLYFIN_DATA_DIR}  -P | pv -s $(du -sb ${JELLYFIN_DATA_DIR} | awk '{print $1}') | gzip > ${DATA_TAR}
    #tar -zcf ${DATA_TAR} -C ${JELLYFIN_DATA_DIR} .
fi

# Start Jellyfin
systemctl start jellyfin

cd -
