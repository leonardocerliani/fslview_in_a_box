# fslview in a box

## Aim
I run fsl 6.0.8 in a remote Ubuntu 22.04 server. To view the images, I would use fsleyes. However there are problems either with OpenGL or wxpython, especially in certain Linux distros and over SSH. These problems are repeatedly mentioned in the fsl jiscmail list, and also mentioned in the [fsleyes installation page](https://open.win.ox.ac.uk/pages/fsl/fsleyes/fsleyes/userdoc/install.html).

All I need it a lightweight image viewer like the previous `fslview`. However it has been removed from recent distributions.

The solution is to run it in a Docker.


## Pulling an FSL 5.0 docker image
The Dockerfile in this repo is from [this great tutorial](https://github.com/giulia-berto/docker-tutorial).

```bash
docker build --tag fslview:5.0 .
```

To have fslview run in the host, it is necessary to map the local `/tmp/.X11-unix` directory and the local `PWD` so that we can access the images in the local folder. Also the `$DISPLAY` env var must be mapped. 

Finally, I observed that in some cases setting only these two parameters leads to refused connection with the local X server. Therefore - after many hours of search, trials and especially errors - I found out that it is necessary also to map the local `Xauthority` env_var/directory and put host and container in the same network with `--net=host`. 

(if you want to know the function of each parameter, just ask ChatGPT - it does a pretty good job)

To test it, run:

```bash
docker run --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --net=host \
    -e DISPLAY=unix$DISPLAY \
    -v $(pwd):/home/user \
    -e XAUTHORITY=/home/user/.Xauthority \
    -v $HOME/.Xauthority:/home/user/.Xauthority \
    -t fslview:5.0 fslview
```

## Run with the image as an argument
The main intended usage of this fslview is to provide also the filename of the image we want to view.

To this aim, we will build a bash script which launches the container and runs fslview. When calling the script, you need to provide also the filename of the image to visualize.

If we want to add more images, we can do that once inside fslview.

We call this script `fslview.sh` and we will place it in a place within the path, e.g. `/usr/local/bin`


```bash
#!/bin/bash

[ -z "$1" ] && { echo "Specify a valid nifti image please!"; exit 1; }

image=$1

docker run --rm \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --net=host \
    -e DISPLAY=unix$DISPLAY \
    -v $(pwd):/home/user \
    -e XAUTHORITY=/home/user/.Xauthority \
    -v $HOME/.Xauthority:/home/user/.Xauthority \
    -t fslview:5.0 fslview /home/user/${image}
```

By the way, this works also when connecting via `ssh -X`, however in this case the transfer times for rendering the X app and loading the images become geological, so it's not really practical.



## To Do
One of most common uses is to overlay some results onto an MNI template. We will therefore copy some MNI images inside the image during build.








