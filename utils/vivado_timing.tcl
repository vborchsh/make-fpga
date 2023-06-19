set _xil_proj_name_ [lindex $::argv 0]
set _xil_proj_path_ [lindex $::argv 1]

# Open project
open_project $_xil_proj_path_/$_xil_proj_name_

open_run impl_1
set wns [get_property SLACK [get_timing_paths -setup -hold]]
puts "-> WNS: $wns"

set design_timing_pass [expr {$wns < 0}]

if {$design_timing_pass == 1} {
  puts "-> Timings NOT pass"
} else {
  puts "-> Timings pass"
}

close_project
exit $design_timing_pass
