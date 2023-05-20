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
close_project

if {$status != "write_bitstream Complete!"} {
  exit 1
}
exit 0
