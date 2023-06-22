SHELL:=/bin/bash -O extglob

BUILD_NAME?=build
BUILD_PATH?=$(BUILD_NAME)
BUILD_ARCH?=zynq
BUILD_JOBS?=16

.DEFAULT_GOAL:=help

all: create synth impl xsa bin ## Creates project, run synthesys, implementation and exports xsa and bin files;

build: synth impl ## Run synthesys and implementation;

create: ## Creates Vivado's project BUILD_NAME in the BUILD_PATH directory;
	@vivado -nolog -nojournal -notrace -mode batch -source build_project.tcl -tclargs --project_name $(BUILD_NAME)

open: ## Open Vivado's project BUILD_NAME in the BUILD_PATH directory in GUI mode. Project must be created by "create" target
	@vivado -nolog -nojournal -notrace -mode gui $(BUILD_PATH)/$(BUILD_NAME).xpr

save: ## Open Vivado's project and save all settings to the build_project.tcl file by calling write_project_tcl;
	@vivado -nolog -nojournal -notrace -mode batch -source make-fpga/utils/vivado_save_project.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH)

synth: ## Open and run synthesis for BUILD_NAME project. The project must be created by "create" target;
	@echo 'Starts synthesis with $(BUILD_JOBS) jobs'
	@vivado -nolog -nojournal -notrace -mode batch -source make-fpga/utils/vivado_synth.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH) $(BUILD_JOBS)

impl: ## Open and run implementation for BUILD_NAME project. The project must be synthesized by "synth" target;
	@echo 'Starts implementation with $(BUILD_JOBS) jobs'
	@vivado -nolog -nojournal -notrace -mode batch -source make-fpga/utils/vivado_impl.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH) $(BUILD_JOBS)

xsa: ## Export .xsa file to the project's root;
	@vivado -nolog -nojournal -notrace -mode batch -source make-fpga/utils/vivado_export_xsa.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH)

timing: ## Check timing, return 1 in case slacks < 0;
	@vivado -nolog -nojournal -notrace -mode batch -source make-fpga/utils/vivado_timing.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH)

bin: ## Converts .bin file to the .bit.bin and copy it to the project's root. BUILD_ARCH should be checked!;
	@echo "all: { $(BUILD_PATH)/$(BUILD_NAME).runs/impl_1/top.bit /* Bitstream file name */ }" > make-fpga/utils/image.bif
	bootgen -w -image make-fpga/utils/image.bif -arch $(BUILD_ARCH) -process_bitstream bin
	@cp $(BUILD_PATH)/$(BUILD_NAME).runs/impl_1/top.bit.bin ./
	@echo The .bit.bin file has been generated
	@ls -la top.bit.bin

clean: ## Delete everything;
	@rm -rf $(BUILD_PATH) .Xil *.bit.bin *.xsa
	@rm -rf bd/**/!(hdl|*.bd)
	@rm -rf core/xilinx/ipshared
	@rm -rf core/xilinx/**/!(*.xci)

template: ## Generates template project's structure with folders and gitignore;
	@echo "This target will build template project's structure in the folder:"
	@echo $(shell pwd)
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	@cp -r make-fpga/template/* .
	@echo "Done!"
	@ls -la

help: ## Print this help.
	@echo "make-fpga is set of scripts for handling Vivado's non-project mode design flow"
	@echo ""
	@echo "Available options:"
	@echo "BUILD_NAME?=build - project name;"
	@echo "BUILD_PATH?=BUILD_NAME - project path (folder with BUILD_NAME.* subfolders);"
	@echo "BUILD_ARCH?=zynq - architecture (zynq, zynqmp, fpga). Applicable only for 'bin' target."
	@echo "BUILD_JOBS?=16 - Number of threads for Vivado. Applicable only for 'synth' and 'impl' target."
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
	@echo ""

.PHONY: all build create open save synth impl xsa bin clean template help
