# Jellyfin-Backup-Restore

Scripts to backup and restore Jellyfin data.

The backups create a tarball of Jellyfin config and/or media.

It will also create a backup of the existing config in `backup/old_config` and `backup/old_media` before doing a restore (in case something goes wrong).

**Important:** Make sure that you stop Jellyfin before running the backup script.

## Setup

```bash
cp example.env .env
```

Update the following values:

* `JELLYFIN_VERSION`: Current Jellyfin version
* `JELLYFIN_CONFIG_DIR`: Absolute path to your Jellyfin config dir
    * If empty, the script will not backup the config
* `JELLYFIN_MEDIA_DIR`: Absolute path to your media dir
    * If empty, the script will not backup the media
* `BACKUP_EXISTING_CONFIG`:
    * `0`: Do not backup the existing config before restoring
    * `1`: Backup the existing config before restoring
* `BACKUP_EXISTING_MEDIA`: 
    * `0`: Do not backup the existing media before restoring
    * `1`: Backup the existing media before restoring
* `BACKUPS`: Backup directory (absolute or relative path). By default, this will backup to`./backup`
* `CONFIG_TAR`: Config tarball filename
* `MEDIA_TAR`: Media tarball filename

## Backup

The media/config tarballs are saved in `backup/version-date.time`

In my case, I use docker, so:

```bash
cd <jellyfin_dir>
docker compose down

cd <jellyfin_backup_restore>
./backup.sh

cd <jellyfin_dir>
docker compose up -d
```

## Restore

The `restore.sh` script takes a single argument (the backup directory name), e.g.

for:

```text
├── backup
│   ├── 10.10.3-2024.12.31.08.36.35
│   │   ├── jellyfin.config.tgz
│   │   ├── jellyfin.media.tgz
```

run:

```bash
./restore.sh 10.10.3-2024.12.31.08.36.35
```

In my case, I use docker, so:

```bash
cd <jellyfin_dir>
docker compose down

cd <jellyfin_backup_restore>
./restore.sh <backup_directory>

cd <jellyfin_dir>
docker compose up -d
```

## Revert to pre-restore data

### Config

```bash
cd <jellyfin_dir>
docker compose down

sudo rm -R <jellyfin_config_dir>/*
cd <jellyfin_backup_restore>
cp -Rp backup/old_config/* <jellyfin_config_dir>/

cd <jellyfin_dir>
docker compose up -d
```

### Media

```bash
cd <jellyfin_dir>
docker compose down

sudo rm -R <jellyfin_media_dir>/*
cd <jellyfin_backup_restore>
cp -Rp backup/old_media/* <jellyfin_media_dir>/

cd <jellyfin_dir>
docker compose up -d
```
