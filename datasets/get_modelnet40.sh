#!/bin/bash

#--- Switch to the correct path (where the script is in)
backpath=`pwd`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

#--- Download the compressed file
wget -nc http://vision.princeton.edu/projects/2014/3DShapeNets/ModelNet40.zip

#--- Extract it
unzip ModelNet40


#--- Go back to the initial directory
cd $backpath
