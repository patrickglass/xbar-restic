#!/bin/sh
# Restic xbar plugin for daily backups
#
#  <xbar.title>Restic Backup</xbar.title>
#  <xbar.version>v0.1.0</xbar.version>
#  <xbar.author>Patrick Glass</xbar.author>
#  <xbar.author.github>patrickglass</xbar.author.github>
#  <xbar.desc>Run an automated backup of your system to a restic repo.</xbar.desc>
#  <xbar.image>https://raw.githubusercontent.com/patrickglass/xbar-restic/main/assets/logo/noun_backup_3730375.png</xbar.image>
#  <xbar.dependencies>restic</xbar.dependencies>
#  <xbar.abouturl>https://github.com/patrickglass/xbar-restic</xbar.abouturl>

# Variables become preferences in the app:
#
#  <xbar.var>string(RESTIC_REPOSITORY="sftp:nas:/mnt/pool/backup/restic_backup"): Restic Repository.</xbar.var>
#  <xbar.var>string(VAR_BACKUP_WORK=~/): Primary work directory to backup.</xbar.var>
#  <xbar.var>string(VAR_BACKUP_TAG=work): Tag name for primary work directory backup.</xbar.var>
#  <xbar.var>boolean(VAR_BACKUP_HOME=true): Whether to backup home directory files.</xbar.var>
#  <xbar.var>boolean(VAR_RESTIC_PRUNE=true): Whether to forget and prune old snapshots.</xbar.var>


echo "Restic"
echo "---"

if [ -z "$VAR_BACKUP_HOME" ]; then
  restic backup -x --exclude-caches \
      ~/*.sh ~/.profile ~/.bashrc ~/.fzf.bash ~/.fzf.zsh ~/.zshrc \
      ~/.kubectl_aliases ~/.gitconfig ~/.gitignore \
      ~/.terraformrc ~/.vimrc
  echo "Home - OK"
fi

restic backup \
    -x --exclude-caches \
    --exclude vendor --exclude .eggs \
    --exclude venv --exclude node_modules --exclude .tox \
    --exclude .terraform --exclude .vagrant \
    --tag $VAR_BACKUP_TAG \
    $VAR_BACKUP_WORK
echo "Work - OK"

if [ -z "$VAR_RESTIC_PRUNE" ]; then
  restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 12 --keep-yearly 1 --prune
  echo "Prune - OK"
fi

echo "All - OK"
