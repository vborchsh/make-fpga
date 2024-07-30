set _proj_name_ [lindex $::argv 0]
set _proj_path_ [lindex $::argv 1]
set _jobs_ [lindex $::argv 2]
set _strategy_ [lindex $::argv 3]

set run_name impl_1$_strategy_

# Open project
open_project $_proj_path_/$_proj_name_
update_compile_order -fileset sources_1

# Implementation
create_run $run_name -strategy $_strategy_
reset_run $run_name
launch_runs $run_name -to_step write_bitstream -jobs $_jobs_
wait_on_run $run_name

# Done
set status [get_property STATUS [get_runs $run_name]]
close_project

if {$status != "write_bitstream Complete!"} {
  exit 1
}
exit 0
