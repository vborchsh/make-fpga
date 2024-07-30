set _proj_name_ [lindex $::argv 0]
set _proj_path_ [lindex $::argv 1]

open_project $_proj_path_/$_proj_name_

write_project_tcl -no_copy_sources -use_bd_files -quiet -force -internal build_project.tcl
