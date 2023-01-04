BUILD_NAME?=build

all:
	@echo "Default is disabled, specify your task"
	@echo "Available: "
	@echo "  - template;"
	@echo "  - create;"
	@echo "  - open;"
	@echo "  - save;"
	@echo "  - synth;"
	@echo "  - impl;"
	@echo "  - export_xsa;"
	@echo "  - export_bin;"
	@echo "  - clean."

create:
	@vivado -nolog -nojournal -notrace -mode batch -source build_project.tcl -tclargs --project_name $(BUILD_NAME)

open:
	@vivado -nolog -nojournal -notrace -mode gui -source build_project.tcl -tclargs --project_name $(BUILD_NAME)

save:
	@vivado -nolog -nojournal -notrace -mode batch -source make-fpga/save_project.tcl -tclargs $(BUILD_NAME) $(BUILD_NAME)

synth: create
	@vivado -nolog -nojournal -notrace -mode batch -source make-fpga/synth.tcl -tclargs $(BUILD_NAME) $(BUILD_NAME)

impl: create
	@vivado -nolog -nojournal -notrace -mode batch -source make-fpga/synth_impl.tcl -tclargs $(BUILD_NAME) $(BUILD_NAME)

export_xsa:
	@vivado -nolog -nojournal -notrace -mode batch -source make-fpga/export_xsa.tcl -tclargs $(BUILD_NAME) $(BUILD_NAME)

export_bin:
	@echo "all: { $(BUILD_NAME)/$(BUILD_NAME).runs/impl_1/top.bit /* Bitstream file name */ }" > make-fpga/image.bif
	bootgen -w -image make-fpga/image.bif -arch zynq -process_bitstream bin
	@cp $(BUILD_NAME)/$(BUILD_NAME).runs/impl_1/top.bit.bin ./
	@echo The .bit.bin file has been generated
	@ls -la top.bit.bin

clean:
	@rm -rf $(BUILD_NAME) .Xil *.bit.bin *.xsa

template:
	@echo -n "The target are going to build template project structure in the current folder. Are you sure? [y/N] " && read ans && [ $${ans:-N} = y ]
	@mkdir bd
	@mkdir constr
	@mkdir core
	@mkdir rtl
	@mkdir sim
	@echo '# Simulation' > .gitignore
	@echo 'sim/**/work' >> .gitignore
	@echo 'sim/**/*.wlf' >> .gitignore
	@echo 'sim/**/sim_build' >> .gitignore
	@echo 'sim/**/transcript' >> .gitignore
	@echo 'sim/**/modelsim.ini' >> .gitignore
	@echo '' >> .gitignore
	@echo '# Hardware platform' >> .gitignore
	@echo '.Xil' >> .gitignore
	@echo '*.jou' >> .gitignore
	@echo '*.log' >> .gitignore
	@echo '*.str' >> .gitignore
	@echo '*.bit.bin' >> .gitignore
	@echo '*.xsa' >> .gitignore
	@echo '*.bif' >> .gitignore
	@echo 'build' >> .gitignore
	@echo '' >> .gitignore
	@echo '/bd/**/*.*' >> .gitignore
	@echo '!/bd/**/*.bd' >> .gitignore
	@echo '!/bd/**/*_wrapper*' >> .gitignore
	@echo '' >> .gitignore
	@echo 'core/ipshared' >> .gitignore
	@echo 'core/xilinx/**/*.*' >> .gitignore
	@echo '!core/xilinx/**/*.xci' >> .gitignore
	@echo '!core/xilinx/**/*.xcix' >> .gitignore
	@echo "Done!"
	@ls -la

.PHONY: all create open save synth impl export_xsa export_bin clean
