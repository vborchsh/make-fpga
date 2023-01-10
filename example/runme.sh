#!/bin/bash

# Prepare repos
mkdir example_repo
cd example_repo
git init
git submodule add https://github.com/vborchsh/make-fpga ./make-fpga
# Create template
make -f make-fpga/Makefile template
