# fslview in a box

## Aim
I run fsl 6.0.8 in a remote Ubuntu 22.04 server. To view the images, I would use fsleyes. However there are problems either with OpenGL or wxpython.

All I need it a lightweight image viewer like the previous `fslview`. However it has been removed from recent distributions.

The solution is to run it in a Docker


## Pulling an FSL 5.0 docker image
The Dockerfile in this repo is from [this great tutorial](https://github.com/giulia-berto/docker-tutorial).

```
docker build --tag fslview:5.0 .
```

The image contains fslview. It is necessary to map the local `/tmp/.X11-unix` directory and the local `PWD` so that we can access the images in the local folder. Also the `$DISPLAY` env var must be mapped.

To test it, run:

```
docker run --rm \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$DISPLAY \
	-v $(pwd):/home/user \
	-t fslview:5.0 fslview
```

## Run with the image as an argument
The main intended usage of this fslview is to provide also the filename of the image we want to view

