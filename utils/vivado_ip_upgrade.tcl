# Based on https://github.com/hukenovs/tcl_for_fpga by Kapitanov
# Upgrade standalone IPs only, not in block design.

set _xil_proj_name_ [lindex $::argv 0]
set _xil_proj_path_ [lindex $::argv 1]

# Open project
open_project $_xil_proj_path_/$_xil_proj_name_

# Collect all cores list
set ip_cores_list [get_ips]

# Check every core and update `locked` AND not `upgraded` AND not in `BD`
for {set i 0} {$i < [llength $ip_cores_list]} {incr i} {
    set ip_core_inst [lindex $ip_cores_list $i]

    set locked [get_property IS_LOCKED $ip_core_inst]
    set upgrade [get_property UPGRADE_VERSIONS $ip_core_inst]
    set inside_bd [get_property IS_BD_CONTEXT $ip_core_inst]
    if {$upgrade != "" && $locked && !$inside_bd} {
        upgrade_ip $ip_core_inst -log ip_upgrade.log
    }
}

close_project

exit 0
