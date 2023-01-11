# make-FPGA

Set of scripts for handling Vivado's project in non-project mode.

## Example

Here is a bunch of commands for creating example project.

```
git clone https://github.com/vborchsh/make-fpga
cd make-fpga/example
source runme.sh
```

> Please, pay attention that you **must** run Make with -f key.

Now, you are in the `example_repo` folder with everything needed inside. And you can do:

```
make -f make-fpga/Makefile # This will give you some details
make -f make-fpga/Makefile all # And this will build everything
```

## Details

### Project's creating

You can run `template` target in empty folder and script will build repository's structure with files from `template` folder. The repository is created with a structure from the article: https://habr.com/ru/post/683580/. But you can modify these files to align to your needs.

Also, you can use command:

```
make -f make-fpga/Makefile save BUILD_NAME=<project name>
```

To save existing project to `build_project.tcl`.

### Project's deploy

In short terms:

```
git clone <project link> --recursive
cd <project name>
make -f make-fpga/Makefile all
```

### Project's updating

In short terms:

In case any changes in the project's structure and/or parameters (fileset, paths,
compilation settings and so on) you have to run before commit:

```
make -f make-fpga/Makefile save
```
