#!/usr/bin/env bash

if [ ! -d ${MINECRAFT_MODS_DIR} ]; then
    echo "> creating mods dir"
    mkdir -p ${MINECRAFT_MODS_DIR}
fi

if [ ! -d ${MINECRAFT_BACKUPS_DIR} ]; then
    echo "> creating backups dir"
    mkdir -p ${MINECRAFT_BACKUPS_DIR}
fi

if [ ! -L ${MINECRAFT_GAME_DIR}/backups ]; then
    echo "> creating backups symlink"
    ln -sf ${MINECRAFT_BACKUPS_DIR} ${MINECRAFT_GAME_DIR}/backups
fi
