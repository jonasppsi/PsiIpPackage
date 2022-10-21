variable fileLoc [file normalize [file dirname [info script]]]
namespace export -clear *
variable CurrentNamespace   [namespace tail [namespace current]]
variable TestStr            $CurrentNamespace

###################################################################################################
# Add new procedures
###################################################################################################
proc version_check {packageversion} {
    variable VivadoVersion      [version -short]
    
    if {[package vcompare $packageversion $VivadoVersion] == 1} {
        error "ERROR: Current IpPackager version ($packageversion) is not supported by Vivado version ($VivadoVersion). Please update package.tcl or downgrade Vivado version."
    } else {
        puts "INFO: Current IpPackager version ($packageversion) is supported by Vivado version ($VivadoVersion)."
    }
}

proc baa {} {
    variable TestStr
    puts $TestStr
}

proc old {} {
    variable TestStr
    puts $TestStr
}

proc foo {} {
    variable TestStr
    puts $TestStr
}

proc set_vendor {} {
  puts "bla"
}
