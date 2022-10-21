variable fileLoc [file normalize [file dirname [info script]]]
namespace import -force ::PSTU::2020_1::*
namespace export -clear *
variable CurrentNamespace   [namespace tail [namespace current]]
variable TestStr            $CurrentNamespace

###################################################################################################
# Overwritte inherited procedures
###################################################################################################
proc abb {} {
    variable TestStr
    puts $TestStr
}

###################################################################################################
# Add new procedures
###################################################################################################

proc zah {} {
    variable TestStr
    puts $TestStr
}

proc xyt {} {
    variable TestStr
    puts $TestStr
}

proc set_logo_relative {} {
    variable TestStr
    puts $TestStr
}
###################################################################################################
# Define deprecated procedures
###################################################################################################
proc foo {} {
    variable CurrentNamespace
    error "DEPRECATED: Procedure foo() was removed in IpPackage_${CurrentNamespace}. Please consult the Command Reference."
}


