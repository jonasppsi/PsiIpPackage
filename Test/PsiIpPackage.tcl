variable fileLoc [file normalize [file dirname [info script]]]

if {[namespace exists ::PSTU] == 1} {
    namespace delete ::PSTU
}

namespace eval ::PSTU::2017_2 {
	source -notrace "$fileLoc/IpPackage_2017_2.tcl"
}

namespace eval ::PSTU::2020_1 {
	source -notrace "$fileLoc/IpPackage_2020_1.tcl"
}

namespace eval ::PSTU::2022_1 {
	source -notrace "$fileLoc/IpPackage_2022_1.tcl"
}
