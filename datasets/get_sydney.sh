#!/bin/bash

#--- Switch to the correct path (where the script is in)
backpath=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#--- Download the compressed file
wget -nc http://www.acfr.usyd.edu.au/papers/data/sydney-urban-objects-dataset.tar.gz #This is the original dataset (we just need some lists from it)
wget -nc https://lmb.informatik.uni-freiburg.de/resources/datasets/ORION/aligned_sydney_objects.tar.gz # This is our version, containing PLY files, aligned and original

#--- Extract it
mkdir -p Sydney/original
tar -xvf sydney-urban-objects-dataset.tar.gz -C Sydney/original
tar -xvf aligned_sydney_objects.tar.gz -C Sydney


#--- Go back to the initial directory
cd $backpath
