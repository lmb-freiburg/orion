#!/bin/bash

#--- Switch to the correct path (where the script is in)
backpath=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#--- Download the compressed file -- this is our aligned version
wget -nc https://lmb.informatik.uni-freiburg.de/resources/datasets/ORION/aligned_sydney_objects.tar.gz

#--- Extract it
mkdir -p Sydney
tar -xvf aligned_sydney_objects.tar.gz -C Sydney


#--- Go back to the initial directory
cd $backpath
