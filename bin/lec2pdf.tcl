lappend auto_path "[pwd]/lib/"
package require pdf4tcl

if {![file exists {../input/}]} {
  file mkdir {../input/} {../output/}
}
cd {../input/}
foreach dir [set dirs [glob -nocomplain -- *]] {
  puts $dir
}
puts {Enter directory name, non-existent to exit}
if {[lsearch $dirs [set dir [gets stdin]]]+1} {
cd $dir
puts {Enter file format, defaults to jpeg}
if {[gets stdin]=={png}} {
  set ext {{*.png}}
  set type png
} {
  set ext {*.{jpeg,jpg,JPG}}
  set type jpeg
}
puts "Processing..."
::pdf4tcl::new document -file "../../output/${dir}.pdf" 
set width  [string range [lindex [::pdf4tcl::getPaperSize a6] 0] 0 end-2]
set height [string range [lindex [::pdf4tcl::getPaperSize a6] 1] 0 end-2]
set counter 0
set files [lsort -dictionary -unique [glob -nocomplain -- $ext]]
set max [llength $files]
foreach filename $files {
  incr counter
  puts "Page number ${counter}:${max}"
  document startPage -paper a6
  document putImage [document addImage $filename -type $type] 0 0 -width $width -height $height
}
document finish
document destroy
}
exit                                                                                                                   
