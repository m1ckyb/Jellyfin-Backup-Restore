# Jellyfin-Backup-Restore

Scripts to backup and restore Jellyfin data.

The backups create a tarball of Jellyfin config and/or media.

It will also create a backup of the existing config in `backup/old_config` and `backup/old_media` before doing a restore (in case something goes wrong).

## Setup

```bash
cp example.env .env
```

Update the following values:

* `JELLYFIN_VERSION`: currennt Jellyfin version
* `JELLYFIN_CONFIG_DIR`: absolute path to your Jellyfin config dir
    * If empty, the script will not backup/restore config
* `JELLYFIN_MEDIA_DIR`: absolute path to your media dir
    * If empty, the script will not backup/restore media
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

The media/config tarballs are saved in backup/jellyfin_version-year.month.day.hour.minute.second

Make sure that you stop Jellyfin before running the backup script.

In my case, I use docker, so:

```bash
cd <jellfin_dir>
docker compose down

cd <jellyfin_backup_restore>
./backup.sh

cd <jellfin_dir>
docker compose up -d
```

## Restore

Make sure that you stop Jellyfin before running the backup script.

In my case, I use docker, so:

```bash
cd <jellfin_dir>
docker compose down

cd <jellyfin_backup_restore>
./restore.sh <backup_directory>

cd <jellfin_dir>
docker compose up -d
```

## Revert to pre-restore data

### Config

```bash
cd <jellyfin_backup_restore>
cp -Rp backup/old_config/* <jellyfin_config_dir>
```

### Media

```bash
cd <jellyfin_backup_restore>
cp -Rp backup/old_media/* <jellyfin_media_dir>
```
