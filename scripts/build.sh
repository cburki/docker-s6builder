#!/bin/bash

SRC_DIR=/data/s6src
DIST_DIR=/data/s6dist

mkdir -p ${SRC_DIR}
mkdir -p ${DIST_DIR}


function download_archives {

    cd ${SRC_DIR}
    curl -O http://skarnet.org/software/skalibs/skalibs-${SKALIBS_VERSION}.tar.gz
    curl -O http://skarnet.org/software/execline/execline-${EXECLINE_VERSION}.tar.gz
    curl -O http://skarnet.org/software/s6/s6-${S6_VERSION}.tar.gz
}

function build_skalibs {

    cd ${SRC_DIR}
    tar zxvf skalibs-${SKALIBS_VERSION}.tar.gz
    cd skalibs-${SKALIBS_VERSION}
    ./configure --prefix=${DIST_DIR} --enable-static --disable-shared
    make
    make install
}

function build_execline {

    cd ${SRC_DIR}
    tar zxvf execline-${EXECLINE_VERSION}.tar.gz
    cd execline-${EXECLINE_VERSION}
    ./configure --prefix=${DIST_DIR} --with-include=${DIST_DIR}/include/ --with-lib=${DIST_DIR}/lib/skalibs/ --enable-static --disable-shared
    make
    make install
}

function build_s6 {

    cd ${SRC_DIR}
    tar zxvf s6-${S6_VERSION}.tar.gz
    cd s6-${S6_VERSION}
    ./configure --prefix=${DIST_DIR} --with-include=${DIST_DIR}/include/ --with-lib=${DIST_DIR}/lib/skalibs --with-lib=${DIST_DIR}/lib/execline --enable-static --disable-shared
    make
    make install
}


# Build
download_archives
build_skalibs
build_execline
build_s6
