###################################################################################################
#  Copyright (c) 2019 by Paul Scherrer Institute, Switzerland
#  All rights reserved.
###################################################################################################

###################################################################################################
# PSI Vivado IP Package Package
###################################################################################################
# This package helps to easily package IP in vivado from TCL scripts.
# The package is specifically written with portability between different
# Vivado versions in mind and all versions every created stay accessible
# (i.e. IP can be packaged with older versions also in future).
#

namespace eval ::psi::ip_package {
    variable fileLoc [file normalize [file dirname [info script]]]
    source $fileLoc/scripts/utils/PsiUtilPath.tcl
    source $fileLoc/scripts/utils/PsiUtilString.tcl
}

namespace eval ::psi::ip_package::2017_2_1 {
	source "${::psi::ip_package::fileLoc}/scripts/IpPackage_2017_2_1.tcl"
}

namespace eval psi::ip_package::latest {
	source "${::psi::ip_package::fileLoc}/scripts/IpPackage_2017_2_1.tcl"
}

namespace eval psi::ip_package::2020_1 {
	source "${::psi::ip_package::fileLoc}/scripts/IpPackage_2020_1.tcl"
}
          