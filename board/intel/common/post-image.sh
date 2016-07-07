#!/bin/sh -e
# SPDX-License-Identifier: GPL-2.0

#
# Copyright (c) 2016 Intel Corp.
#

SCRIPT_LOCATION="$(dirname $0)"
SCRIPT_DIR="$SCRIPT_LOCATION/post-image.d"

find "$SCRIPT_DIR" -maxdepth 1 -type f -perm -u+x | sort -u | while read script; do
	name=$(basename $script)

	echo "Executing $name..."

	$script "$@"
done
