# Builds a Docker image for PETSc
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/desktop:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

# Install system packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        gcc \
        gfortran \
        bison \
        flex \
        git \
        bash-completion \
        bsdtar \
        rsync \
        wget \
        gdb \
        ccache \
        \
        libopenblas-base \
        libopenblas-dev \
        \
        openmpi-bin libopenmpi-dev \
        libscalapack-openmpi1 libscalapack-mpi-dev \
        libsuperlu-dev \
        libsuitesparse-dev \
        libhypre-dev \
        libblacs-openmpi1 libblacs-mpi-dev \
        libptscotch-dev \
        libmumps-dev \
        \
        libpetsc3.7.6-dev && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PETSC_DIR=/usr/lib/petscdir/3.7.6/x86_64-linux-gnu-real

########################################################
# Customization for user
########################################################
RUN echo "export OMP_NUM_THREADS=\$(nproc)" >> $DOCKER_HOME/.profile && \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME

WORKDIR $DOCKER_HOME
