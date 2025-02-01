#!/bin/bash

[ -z "$1" ] && { echo "Specify a valid nifti image please!"; exit 1; }
# e.g. ./fslview_linux.sh MNI152_T1_1.25mm_brain.nii.gz

image=$1

docker run --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --net=host \
    -e DISPLAY=unix$DISPLAY \
    -v $(pwd):/home/user \
    -e XAUTHORITY=/home/user/.Xauthority \
    -v $HOME/.Xauthority:/home/user/.Xauthority \
    -t fslview:5.0 fslview /home/user/${image}

# EOF