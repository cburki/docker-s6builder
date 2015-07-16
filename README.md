Summary
-------

When Docker launches a container, your *ENTRYPOINT* process is launched as *process id 1* - and on nearly any Linux system, whether it’s a physical install, a virtual machine, or a container, *process id 1* has a special role. When any orphaned/disowned process exits, *process id 1* is supposed to clean up after it.

[S6][1] is a small suite of programs designed to allow process supervision. It is meant to run as *process id 1*.

This image allow to build the s6 programs which you can then use in your containers.


Build the image
---------------

To create this image, execute the following command in the docker-s6builder folder.

    docker build \
        -t cburki/s6builder \
        .


Run the image
-------------

When you run the image, you must specify the versions of the s6 programs and their dependencies you would like to build. You can found the latest version on the [s6][1] web site.

    docker run \
        --name s6builder \
        --rm \
        -v /<full path to data>:/data \
        -e SKALIBS_VERSION=2.3.5.1 \
        -e EXECLINE_VERSION=2.1.2.2 \
        -e S6_VERSION=2.1.6.0 \
        -i \
        -t \
        cburki/s6builder

The results of the build (binaries, libraries, etc) could then be found in *s6dist* folder of the data volume. The *s6src* folder contains the sources.


Using s6 to start services
--------------------------

The s6 main init-like program is *s6-svscan*. When launched, it will parse a directory a launch *s6-supervise* on each *service directories* it found. Here is a sample of my directory tree for a ssh server container.

    etc
    └── s6
        ├── .s6-svscan
        │   └── finish
        └── sshd
            ├── finish
            └── run

*/etc/s6* is the root s6 directory where sshd is a *service directory*. The *.s6-svscan* is not a service directory, that's the directory used by *s6-svscan*.

Each *service directory* has two files, run and finish. The *s6-supervise* program will call the run program, and when the run program exits, it will call the finish program. Here is my run program for sshd service.

    #!/bin/bash
    
    /usr/bin/sshd -D

And here is the finish script. It does nothing because I do not need cleanup.

    #!/bin/bash
    
    exit 0


  [1]: http://skarnet.org/software/s6/