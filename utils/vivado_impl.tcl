set _xil_proj_name_ [lindex $::argv 0]
set _xil_proj_path_ [lindex $::argv 1]
set _xil_jobs_ [lindex $::argv 2]

set run_name impl_1

# Open project
open_project $_xil_proj_path_/$_xil_proj_name_
update_compile_order -fileset sources_1

# Implementation
reset_run $run_name
launch_runs $run_name -to_step write_bitstream -jobs $_xil_jobs_
wait_on_run $run_name

# Done
set status [get_property STATUS [get_runs $run_name]]
set top_module [get_property top [current_fileset]]
close_project

if {$status != "write_bitstream Complete!"} {
  exit 1
} else {
  # Copy bitstream to poject's root folder
  set curr_time [clock format [clock seconds] -format %d-%m-%Y_%H_%M_%S_]
  set bit_path $_xil_proj_path_/$_xil_proj_name_.runs/$run_name

  file rename -force $bit_path/$top_module.bit $bit_path/$curr_time$top_module.bit
  exit 0
}
