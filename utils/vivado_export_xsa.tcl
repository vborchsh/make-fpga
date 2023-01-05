set _xil_proj_name_ [lindex $::argv 0]
set _xil_proj_path_ [lindex $::argv 1]

open_project $_xil_proj_path_/$_xil_proj_name_

write_hw_platform -fixed -force -file $_xil_proj_name_.xsa
