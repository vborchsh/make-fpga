#!/bin/bash

# Prepare repos
mkdir dummy_repo
cd dummy_repo
git init
git submodule add https://github.com/vborchsh/make-fpga ./make-fpga
# Create template
make -f make-fpga/Makefile template
# Dummy project's files
touch ./rtl/dummy_top.sv
cp ../build_project.tcl ./build_project.tcl
