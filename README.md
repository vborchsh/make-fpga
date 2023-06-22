# make-FPGA

Set of scripts for handling Vivado's project in non-project mode.

## Just show me the code!

Example project creating:

```
git clone https://github.com/vborchsh/make-fpga
cd make-fpga/example
source runme.sh
```

Now, you are in the `example_repo` folder with everything needed inside. And you can do:

```
make # This will give you some details
make all # And this will build everything
```

## Details

### Help

First, let's ask for some help:

```
$ make help
make-fpga is set of scripts for handling Vivado's non-project mode design flow

Available options:
BUILD_NAME?=build - project name;
BUILD_PATH?=BUILD_NAME - project path (folder with BUILD_NAME.* subfolders);
BUILD_ARCH?=zynq - architecture (zynq, zynqmp, fpga). Applicable only for 'bin' target.
BUILD_JOBS?=16 - Number of threads for Vivado. Applicable only for 'synth' and 'impl' target.

Available targets:
all        Creates project, run synthesys, implementation and exports xsa and bin files;
bin        Converts .bin file to the .bit.bin and copy it to the project's root. BUILD_ARCH should be checked!;
build      Run synthesys and implementation;
clean      Delete everything;
create     Creates Vivado's project BUILD_NAME in the BUILD_PATH directory;
help       Print this help.
impl       Open and run implementation for BUILD_NAME project. The project must be synthesized by "synth" target;
open       Open Vivado's project BUILD_NAME in the BUILD_PATH directory in GUI mode. Project must be created by "create" target
save       Open Vivado's project and save all settings to the build_project.tcl file by calling write_project_tcl;
synth      Open and run synthesis for BUILD_NAME project. The project must be created by "create" target;
template   Generates template project's structure with folders and gitignore;
timing     Check timing, return 1 in case slacks < 0;
xsa        Export .xsa file to the project's root;
```

### Project from scratch

You can run `template` target in empty folder and script will build repository's structure with files from `template` folder. The repository is created with a structure from the article: https://habr.com/ru/post/683580/. But you can modify these files to align to your needs.

### Existing project

Also, you can save existing project to `build_project.tcl` and align for these scripts:

```
mkdir workspace && cd workspace
git clone https://github.com/vborchsh/make-fpga
cp make-fpga/template/Makefile .
cp -r <folder with your project> .
make save BUILD_NAME=<project name> BUILD_PATH=<project path>
```

Example:

```
BUILD_NAME=top.xpr
BUILD_PATH=top_prj
path to project file: ./top_prj/top.xpr
```
But I preffer keep them the same: BUILD_PATH==BUILD_NAME.

### Project deploy

```
git clone <project link> --recursive
cd <project name>
make all
```

### Project updating

In case any changes in the project's structure and/or parameters (fileset, paths,
compilation settings and so on) you have to run before commit:

```
make save
```

## Errata

Supports only bash, because of `extglob` using.
