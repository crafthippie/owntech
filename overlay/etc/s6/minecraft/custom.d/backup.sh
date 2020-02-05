#!/usr/bin/env bash
source /usr/bin/entrypoint

if [ ! -d ${MINECRAFT_BACKUPS_DIR} ]
then
    echo "> creating backups dir"
    mkdir -p ${MINECRAFT_BACKUPS_DIR}
fi

if [ ! -L ${MINECRAFT_GAME_DIR}/backups ]
then
    echo "> creating backups symlink"
    ln -sf ${MINECRAFT_BACKUPS_DIR} ${MINECRAFT_GAME_DIR}/backups
fi
