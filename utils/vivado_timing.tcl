set _xil_proj_name_ [lindex $::argv 0]
set _xil_proj_path_ [lindex $::argv 1]

# Open project
open_project $_xil_proj_path_/$_xil_proj_name_

open_run impl_1

puts "-> Timings check starts..."
set whs [get_property SLACK [get_timing_paths -hold]]
set wns [get_property SLACK [get_timing_paths -setup]]
puts "-> WHS: $whs"
puts "-> WNS: $wns"

set whs_pass [expr {$whs < 0}]
set wns_pass [expr {$wns < 0}]
set timing_pass [expr {$whs_pass && $wns_pass}]

if {$timing_pass} {
  puts "-> Timings NOT pass"
} else {
  puts "-> Timings pass"
}

close_project
exit $timing_pass
