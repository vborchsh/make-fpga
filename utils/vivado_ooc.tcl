set _xil_proj_name_ [lindex $::argv 0]
set _xil_proj_path_ [lindex $::argv 1]
set _xil_ooc_top_ [lindex $::argv 2]
set _xil_ooc_constr_ [lindex $::argv 3]

# Check variables
if {$_xil_ooc_top_ eq ""} {
  puts "ERROR: You need specify `BUILD_OOC_TOP` variable."
  exit 1
} else {
  puts "INFO: Run OOC flow for BUILD_OOC_TOP=$_xil_ooc_top_"
}

if {$_xil_ooc_constr_ eq ""} {
  puts "INFO: You might specify `BUILD_OOC_CONSTR`."
} else {
  if { [file exists $_xil_ooc_constr_] != 1} {
    puts "ERROR: BUILD_OOC_CONSTR=$_xil_ooc_constr_ is not exist, or you have no access to it."
    exit 1
  } else {
    puts "INFO: Use BUILD_OOC_CONSTR=$_xil_ooc_constr_ as timing constraint file for OOC flow."
  }
}

# Open project
open_project $_xil_proj_path_/$_xil_proj_name_
update_compile_order -fileset sources_1

# Synthesis
synth_design -mode out_of_context -flatten_hierarchy rebuilt -top $_xil_ooc_top_
write_checkpoint ooc_synth_$_xil_ooc_top_.dcp

# Update constraints, if set
if {$_xil_ooc_constr_ ne ""} {
  read_xdc $_xil_ooc_constr_
}

# Implementation
opt_design
place_design
phys_opt_design
route_design
write_checkpoint ooc_impl_$_xil_ooc_top_.dcp

# Done
close_project

exit 0
