set _xil_proj_name_ [lindex $::argv 0]
set _xil_proj_path_ [lindex $::argv 1]

# Open project
open_project $_xil_proj_path_/$_xil_proj_name_
update_compile_order -fileset sources_1

# Synthesis
reset_run synth_1
launch_runs synth_1 -jobs 16
wait_on_run synth_1

# Done
close_project
exit
