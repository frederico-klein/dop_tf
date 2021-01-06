# dop_tch

So the structure so far is a bit convoluted.

But I had an epiphany and I it became less so.

This is a ros package and it maybe should be split to a template to be added as a git upstream in a merge fashion https://gist.github.com/msrose/2feacb303035d11d2d05. I am trying to add all the common stuff to rosdop, so this shouldn't be necessary.

Now the workspace directory has a CATKIN_IGNORE file which prevents it from being looked into by catkin_make.

This contains all the packages to be run inside the container added as submodules.

This catkin_ws is then mounted remotely on the container with ROS and will not contain the CATKIN_IGNORE (because it is on a top directory), so it should catkin_make just fine.

#### TODOs:

- transformers is not working now with the machine as it is.

- need to avoid having to use version 3.5.1 of transformers; the dataset loaders are rubbish.

- also fix the whole libcudart thing. for reference:

    mkdir -p /usr/local/nvidia/lib/

    ln -s /opt/conda/lib/libcudart.so.11.0  /usr/local/nvidia/lib/libcudart.so.10.1
