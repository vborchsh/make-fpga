set _xil_proj_name_ [lindex $::argv 0]
set _xil_proj_path_ [lindex $::argv 1]

open_project $_xil_proj_path_/$_xil_proj_name_

write_project_tcl -no_copy_sources -use_bd_files -quiet -force -internal build_project.tcl
