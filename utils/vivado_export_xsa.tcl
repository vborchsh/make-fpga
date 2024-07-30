set _proj_name_ [lindex $::argv 0]
set _proj_path_ [lindex $::argv 1]

open_project $_proj_path_/$_proj_name_

write_hw_platform -fixed -force -include_bit -file $_proj_name_.xsa
