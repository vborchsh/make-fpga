# make-FPGA

Set of scripts for handling Vivado's project in non-project mode. Supports only bash, because of `extglob` using.

## Example

Commands for creating example project:

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

### Project deploy

In short terms:

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

### Project from scratch

You can run `template` target in empty folder and script will build repository's structure with files from `template` folder. The repository is created with a structure from the article: https://habr.com/ru/post/683580/. But you can modify these files to align to your needs.

Also, you can save existing project to `build_project.tcl`. Near to you project:

```
mkdir workspace && cd workspace
git clone https://github.com/vborchsh/make-fpga
cp make-fpga/template/Makefile .
cp -r <folder with your project> .
make save BUILD_NAME=<project name>
```

Note, `<project name>` and name of folder with project must be the same. Example:

```
project name: top.xpr
folder name: top
path to project file: ./top/top.xpr
```
