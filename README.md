# make-FPGA

Bunch of scripts for handling Vivado's project in non-project mode.

## Example

Here is a bunch of commands for creating example project.

```
git clone https://github.com/vborchsh/make-fpga
cd make-fpga/example
source runme.sh
```

Now, you are in the dummy_repo folder with everything needed inside. And you can do:

> Please, pay attention that you **must** to run Make with -f key.

```
make -f make-fpga/Makefile # This will give you some details
make -f make-fpga/Makefile create # And this will create a project
```

## Details

The repository must be created with a structure from the article: https://habr.com/ru/post/683580/.
Then, you have to create Vivado's project in GUI mode, setup the part, inital files and so on. Then,
run

```
cd <repo name>
make -f make-fpga/Makefile save BUILD_NAME=<project name>
```

Otherwise, you can run `template` target in empty folder and script will build repository's structure.
But you still have to initialize the project by Vivado's GUI.

### Project's deploy

In short terms:

```
git clone <project link> --recursive
cd <project name>
make -f make-fpga/Makefile
```

You'll get help from Make CLI. 

### Project's updating

In short terms:

In case any changes in the project's structure and/or parameters (fileset, paths,
compilation settings and so on) you have to run `make -f make-fpga/Makefile save` before commit.
