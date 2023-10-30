SHELL:=/bin/bash -O extglob

MAKE_FPGA_VER="0.7"

# Environment variables
BUILD_NAME?=build
BUILD_PATH?=$(BUILD_NAME)
BUILD_ARCH?=zynq
BUILD_JOBS?=16
BUILD_USER_TCL?=$(shell bash -c 'read -p "Enter path to TCL script (e.g. /some/script.tcl): " tcl_name; echo $$tcl_name')

# Just aliases
SYNTH_FOLDER=$(BUILD_PATH)/$(BUILD_NAME).runs/synth_1
IMPL_FOLDER=$(BUILD_PATH)/$(BUILD_NAME).runs/impl_1
VIVADO_BATCH=vivado -nolog -nojournal -notrace -mode batch
VIVADO_GUI=vivado -nolog -nojournal -notrace -mode gui
# Check if implementation folder is exist and keep `bitstream` filename with extension
BIT_FILENAME=$(shell [ -d $(IMPL_FOLDER) ] && find $(IMPL_FOLDER) -name "*.bit" | sed "s/.*\///")

.DEFAULT_GOAL:=help

all: impl xsa bin ## Create project, run synthesys, implementation and export xsa and bin files

rebuild: impl ## Run synthesys and implementation

create: $(BUILD_PATH)/$(BUILD_NAME).xpr ## Create BUILD_PATH/BUILD_NAME.xpr project. Skip if project exists

$(BUILD_PATH)/$(BUILD_NAME).xpr:
	@$(VIVADO_BATCH) -source build_project.tcl -tclargs --project_name $(BUILD_NAME)

open: create ## Open BUILD_PATH/BUILD_NAME.xpr project in GUI mode. Create project if needed
	@$(VIVADO_GUI) $(BUILD_PATH)/$(BUILD_NAME).xpr

save: ## Open project and save all settings to the `build_project.tcl`
	@$(VIVADO_BATCH) -source make-fpga/utils/vivado_save_project.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH)

synth: create $(SYNTH_FOLDER)/__synthesis_is_complete__ ## Run synthesis for BUILD_NAME project. Create project if needed

$(SYNTH_FOLDER)/__synthesis_is_complete__:
	@echo 'Starts synthesis with $(BUILD_JOBS) jobs'
	@$(VIVADO_BATCH) -source make-fpga/utils/vivado_synth.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH) $(BUILD_JOBS)

impl: synth ## Run implementation for BUILD_NAME project. Create and synthesise project if needed
	@if [ ! -f "$(IMPL_FOLDER)/$(BIT_FILENAME)" ]; then \
		echo 'Starts implementation with $(BUILD_JOBS) jobs'; \
		$(VIVADO_BATCH) -source make-fpga/utils/vivado_impl.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH) $(BUILD_JOBS); \
	else \
		echo "Nothing to be done for 'impl'. Bitstream file is already exist: $(IMPL_FOLDER)/$(BIT_FILENAME)"; \
		exit 0; \
	fi

xsa: ## Export .xsa file to the project's root
	@$(VIVADO_BATCH) -source make-fpga/utils/vivado_export_xsa.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH)

timing: ## Check timing, return 1 in case WNS and WHS slacks < 0
	@v$(VIVADO_BATCH) -source make-fpga/utils/vivado_timing.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH)

ip_upgrade: ## Upgrade `locked` AND `not updated` IP cores in the project, exclude BD
	@$(VIVADO_BATCH) -source make-fpga/utils/vivado_ip_upgrade.tcl -tclargs $(BUILD_NAME) $(BUILD_PATH)

bin: ## Export .bit.bin to the project's root after implementation. BUILD_ARCH should be checked!
	@if [ "$(BUILD_ARCH)" == "fpga" ]; then \
		echo "Skip $(BIT_FILENAME) binary generation due to BUILD_ARCH=$(BUILD_ARCH) variable"; \
	elif [[ "$(BUILD_ARCH)" = "zynq" || "$(BUILD_ARCH)" = "zynqmp" ]]; then \
		if [ -f $(IMPL_FOLDER)/$(BIT_FILENAME) ]; then \
			echo "all: { $(IMPL_FOLDER)/$(BIT_FILENAME) /* Bitstream file name */ }" > make-fpga/utils/image.bif; \
			bootgen -w -image make-fpga/utils/image.bif -arch $(BUILD_ARCH) -process_bitstream bin; \
			cp $(IMPL_FOLDER)/$(BIT_FILENAME).bin ./; \
			echo "$(BIT_FILENAME).bin file has been generated"; \
		else \
			echo "$(BIT_FILENAME).bin file is not exist"; \
			exit 1; \
		fi \
	else \
		echo "Skip $(BIT_FILENAME).bin binary generation due to unknown BUILD_ARCH=$(BUILD_ARCH) variable"; \
		exit 1; \
	fi

user-tcl: ## Run given TCL script in Vivado console
	@$(VIVADO_BATCH) -source $(BUILD_USER_TCL)

clean: ## Delete project folder, keep IP and BD cache in `core` and `bd` folders
	@rm -rf $(BUILD_PATH) .Xil *.bit.bin *.xsa

clean_bd: ## Clean BD only in `bd` folder
	@rm -rf bd/**/!(hdl|*.bd)

clean_all: clean clean_bd ## Delete everything
	@rm -rf core/xilinx/ipshared
	@rm -rf core/xilinx/**/!(*.xci)

template: ## Generate template project's structure with folders and .gitignore
	@echo "This target will build template project's structure in the folder:"
	@echo $(shell pwd)
	@echo -n "Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	@cp -r make-fpga/template/* .
	@echo "Done!"
	@ls -la

help: ## Print this help
	@echo "make-fpga v$(MAKE_FPGA_VER)"
	@echo "This is a set of Make scripts for handling Vivado's non-project mode design flow"
	@echo ""
	@echo "Available options:"
	@echo "BUILD_NAME?=build - project name"
	@echo "BUILD_PATH?=BUILD_NAME - project path (folder with BUILD_NAME.* subfolders)"
	@echo "BUILD_ARCH?=zynq - architecture (zynq, zynqmp, fpga). Applicable only for 'bin' target"
	@echo "BUILD_JOBS?=16 - Number of threads for Vivado. Applicable only for 'synth' and 'impl' target"
	@echo "BUILD_USER_TCL?=<prompt input> - User TCL script name. Applicable only for 'user-tcl' target"
	@echo ""
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'
	@echo ""

.PHONY: all build create open save synth impl xsa bin clean clean_all template help
