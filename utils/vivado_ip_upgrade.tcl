# Based on https://github.com/hukenovs/tcl_for_fpga by Kapitanov

set _xil_proj_name_ [lindex $::argv 0]
set _xil_proj_path_ [lindex $::argv 1]

# Open project
open_project $_xil_proj_path_/$_xil_proj_name_

# Report status
report_ip_status -name ip_status

# Report all cores
set ip_cores_list [get_ips]

# Check every core and update locked AND not upgraded
for {set i 0} {$i < [llength $ip_cores_list]} {incr i} {
    set ip_core_inst [lindex $ip_cores_list $i]
    
    set locked [get_property IS_LOCKED $ip_core_inst]
    set upgrade [get_property UPGRADE_VERSIONS $ip_core_inst]
    if {$upgrade != "" && $locked} {
        upgrade_ip $ip_core_inst -log ip_upgrade.log
    }
}