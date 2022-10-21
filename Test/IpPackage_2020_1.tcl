variable fileLoc [file normalize [file dirname [info script]]]
namespace import -force ::PSTU::2017_2::*
namespace export -clear *
variable CurrentNamespace   [namespace tail [namespace current]]
variable TestStr            $CurrentNamespace

###################################################################################################
# Overwritte inherited procedures
###################################################################################################
proc foo {} {
    variable TestStr
    puts $TestStr
}

###################################################################################################
# Add new procedures
###################################################################################################
proc abb {} {
    variable TestStr
    puts $TestStr
}

###################################################################################################
# Define deprecated procedures
###################################################################################################

proc old {} {
  error "DEPRECATED!!"
}
