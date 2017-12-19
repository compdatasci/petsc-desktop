# Builds a Docker image for PETSc 2.3.2
#
# Authors:
# Xiangmin Jiao <xmjiao@gmail.com>

FROM x11vnc/desktop:latest
LABEL maintainer "Xiangmin Jiao <xmjiao@gmail.com>"

USER root
WORKDIR /tmp

ENV PETSC_VERSION=2.3.2

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
        libmumps-dev && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER $DOCKER_USER
ENV PETSC_ARCH=linux-gnu-opt

RUN curl http://overtureframework.org/software/petsc-lite-${PETSC_VERSION}-p6.tar.gz | \
        tar zxf - && \
    cd petsc-${PETSC_VERSION}-p6 && \
    export PETSC_DIR=`pwd` && \
    export PETSC_LIB=$PETSC_DIR/lib/$PETSC_ARCH && \
    ./config/configure.py --prefix=/usr/local/petsc-${PETSC_VERSION} \
        --with-debugging=0 --with-fortran=0 --with-matlab=0 \
        --with-mpi=1 --with-shared=1 --with-dynamic=1 && \
    make && \
    sudo make PETSC_DIR=`pwd` install && \
    cd /tmp && \
    rm -rf petsc-${PETSC_VERSION}-p6

# make PETSC_DIR=`pwd` test

ENV PETSC_DIR=/usr/local/petsc-${PETSC_VERSION}

########################################################
# Customization for user
########################################################
USER root

RUN echo "export OMP_NUM_THREADS=\$(nproc)" >> $DOCKER_HOME/.profile && \
    chown -R $DOCKER_USER:$DOCKER_GROUP $DOCKER_HOME

WORKDIR $DOCKER_HOME
