#!/bin/bash

[ -z "$1" ] && { echo "Specify a valid nifti image please!"; exit 1; }

image=$1

docker run --rm -v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$DISPLAY \
	-v $(pwd):/home/user \
	-t fslview:5.0 fslview /home/user/${image}

# EOF