#!/usr/bin/env bash

declare -x MINECRAFT_BACKUPS_DIR
[[ -z "${MINECRAFT_BACKUPS_DIR}" ]] && MINECRAFT_BACKUPS_DIR="${MINECRAFT_DATA_DIR}/backups"

true
