#!/bin/bash

[ -z "$1" ] && { echo "Specify a valid nifti image please!"; exit 1; }
# e.g. ./fslview_macos.sh MNI152_T1_1.25mm_brain.nii.gz

image=$1

# For Mac OS
# - Open XQuartz settings, make sure both Security Preferences are checked
# Check: https://github.com/apptainer/singularity/issues/5524
if ! xhost | grep -q "localhost"; then
    xhost + localhost
fi

docker run --rm \
    -e DISPLAY=docker.for.mac.host.internal:0 \
    -v $(pwd):/home/user \
    -t fslview:5.0 fslview /home/user/${image}

    # # XQuartz does not use UNIX domain sockets for X11 communication like it does on Linux. 
    # # Instead, it relies on TCP/IP networking
    # -v /tmp/.X11-unix:/tmp/.X11-unix \

    # # Since we're not using unix$DISPLAY with a direct socket, the .Xauthority file is irrelevant here.
    # -e XAUTHORITY=/home/user/.Xauthority \
    # -v $HOME/.Xauthority:/home/user/.Xauthority \
    




