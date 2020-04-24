#!/bin/bash -xv
gcdir="/Applications/Google Chrome.app"

if [ -d "$gcdir" ]; then
	find "$gcdir" -type f -name "Google Chrome Helper" | sed 's~/~\\/~g'
fi
