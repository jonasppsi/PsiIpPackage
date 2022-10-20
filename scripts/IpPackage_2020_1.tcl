###################################################################################################
# Copyright (c) 2020 by Paul Scherrer Institute, Switzerland
# All rights reserved.
# Authors: Patrick Studer
###################################################################################################

# Dependencies ####################################################################################
variable fileLoc [file normalize [file dirname [info script]]]
namespace export -clear *

variable CurrentNamespace [namespace tail [namespace current]]

variable CurrentGuiParent "nullptr"
variable CurrentGuiParam  "nullptr"
variable OldXguiFile

# Project Settings Procedures #####################################################################
proc create_package_project {topEntityFile ipiFolder} {
    
    # define message severities:
    reset_msg_config -id  *                     -default_severity
    set_msg_config   -id  {[Ipptcl 7-1550]}     -new_severity "INFO"
    set_msg_config   -id  {[IP_Flow 19-377]}    -new_severity "INFO"
    set_msg_config   -id  {[IP_Flow 19-459]}    -new_severity "INFO"
    set_msg_config   -id  {[IP_Flow 19-3833]}   -new_severity "ERROR"
    set_msg_config   -id  {[IP_Flow 19-5226]}   -new_severity "INFO"
    set_msg_config   -id  {[IP_Flow 19-5905]}   -new_severity "INFO"
    set_msg_config   -id  {[filemgmt 20-730]}   -new_severity "INFO"
    
    # create package project:
    create_project -force package_prj ./package_prj 
    variable addedFile [add_files -norecurse [file normalize $topEntityFile]]
    # set_property file_type  $type $addedFile
    
    # Add Target-Directory to IP-Location
    set_property  ip_repo_paths  $ipiFolder [current_project]
    update_ip_catalog
    
    # create new IPI
    ipx::package_project -root_dir [file normalize $ipiFolder]
    # set_property ROOT_DIRECTORY [file normalize [get_property ROOT_DIRECTORY [ipx::current_core]]] [ipx::current_core]
    
    # apply default family support
    set_property auto_family_support_level "level_1" [ipx::current_core]

    # GUI Initialize (remove auto-generate stuff)
	ipgui::remove_page -component [ipx::current_core] [ipgui::get_pagespec -name "Page 0" -component [ipx::current_core]]
    ipx::remove_bus_interface [get_property name [ipx::get_bus_interfaces -of_objects  [ipx::current_core]]] [ipx::current_core]
    variable OldXguiFile [concat $ipiFolder/xgui/[get_property name [ipx::current_core]]_v[string map {. _} [get_property version [ipx::current_core]]].tcl]

}

proc synth_package_project {{jobs 4}} {
    reset_run synth_1
    launch_runs synth_1 -jobs $jobs
    wait_on_run synth_1
    set status [get_property STATUS [get_runs synth_1]]
    if {$status != "synth_design Complete!"} {
        error "Synthesis Failed: $status - Check reports!"
    }   
}

proc save_package_project {} {
    variable OldXguiFile
    
    ipx::merge_project_changes files [ipx::current_core]
    puts "*** Convert all File Group paths to relative paths ***"
	foreach obj [ipx::get_files -of_objects [ipx::get_file_groups * -of_objects [ipx::current_core]]] {
        if {[get_property type $obj] != "unknown"} {
            set file [get_property ROOT_DIRECTORY [ipx::current_core]]/[get_property name $obj]
            set_property name [psi::util::path::relTo [get_property ROOT_DIRECTORY [ipx::current_core]] $file false] $obj
        }
	}
    ipx::create_xgui_files [ipx::current_core]
	ipx::update_checksums [ipx::current_core]
	ipx::save_core [ipx::current_core]
    ipx::check_integrity -quiet [ipx::current_core]
    #Delete default xgui file
    # TODO: is this concat used?
	variable NewXguiFile [concat [get_property ROOT_DIRECTORY [ipx::current_core]]/xgui/[get_property name [ipx::current_core]]_v[string map {. _} [get_property version [ipx::current_core]]].tcl]
    if {$NewXguiFile != $OldXguiFile} {
		puts "*** Delete Default XGUI File ***"
		file delete -force $OldXguiFile
	}
    set OldXguiFile $NewXguiFile
    update_ip_catalog -rebuild
}

proc close_package_project {} {
    close_project
}

# Identification Procedures #######################################################################
proc set_vendor {vendor} {
    set_property vendor $vendor [ipx::current_core]
}

proc set_library {library} {
    set_property library $library [ipx::current_core]
}

proc set_name {name} {
    set_property name $name [ipx::current_core]
}

proc set_version {version} {
	set_property version $version [ipx::current_core]
}

proc set_core_revision {revision} {
    if {$revision=="auto"} {
        set_property core_revision [clock seconds] [ipx::current_core]
	} else {
		set_property core_revision $revision [ipx::current_core]
	}	
}

proc set_display_name {name} {
    set_property display_name $name [ipx::current_core]
}

proc set_description {description} {
    set_property description $description [ipx::current_core]
}

proc set_vendor_display_name {vendor} {
    set_property vendor_display_name $vendor [ipx::current_core]
}

proc set_company_url {url} {
    set_property company_url $url [ipx::current_core]
}

proc set_taxonomy {taxonomy} {
    set_property taxonomy $taxonomy [ipx::current_core]
}

# Compartibility Procedures #######################################################################
proc set_supported_families {families_lifecycle_pairs} {
    set_property auto_family_support_level "level_0" [ipx::current_core]
    set_property supported_families $families_lifecycle_pairs [ipx::current_core]
}

proc enable_auto_familiy_support {level_str} {
    set_property supported_families "" [ipx::current_core]
    set_property auto_family_support_level $level_str [ipx::current_core]
}

proc set_unsupported_simulators {simulators} {
    set_property unsupported_simulators $simulators [ipx::current_core]
}

# File Groups Procedures ##########################################################################

proc copy_files {srcFiles destPath} {
    if {[file isdirectory $destPath] == 0} {
        file mkdir $destPath
    }
    foreach srcFile $srcFiles {
        file copy -force $srcFile $destPath
    }
}

proc add_source_files {files type {library "xil_defaultlib"}} {
    # SystemVerilog-2012, Verilog-2005, VHDL-2002, VHDL-2008 (check UG901)
    # "VHDL" "VHDL 2008" "SystemVerilog" "Verilog Header" "Verilog" "CPP" "C"
    variable addedFiles [add_files -norecurse [file normalize $files]]
    set_property file_type  $type $addedFiles
    if {[string match -nocase "VHDL*" $type]} {
        set_property library $library $addedFiles
    }
    # ipx::merge_project_changes files [ipx::current_core]
}

proc add_subcore_references {subcore} {
    variable fileGroup [ipx::add_file_group -type synthesis {xilinx_anylanguagesynthesis} [ipx::current_core]]
    variable addedFile [ipx::add_subcore [::psi::util::path::relTo [get_property ROOT_DIRECTORY [ipx::current_core]] $subcore false] $fileGroup]
}

proc add_logo {logo} {
    variable fileGroup [ipx::add_file_group -type utility {xilinx_utilityxitfiles} [ipx::current_core]]
    variable addedFile [ipx::add_file [::psi::util::path::relTo [get_property ROOT_DIRECTORY [ipx::current_core]] $logo false] $fileGroup]
    set_property type "LOGO" $addedFile
}

proc add_readme {readme} {
    if       {[string match -nocase "*.pdf"     $readme]} {
        variable type "pdf"
    } elseif {[string match -nocase "*.txt"     $readme] || [string match -nocase "*.md"     $readme]} {
        variable type "text"
    } elseif {[string match -nocase "*.html"    $readme] || [string match -nocase "*.htm"    $readme]} {
        variable type "html"
    } elseif {[string match -nocase "https://*" $readme] || [string match -nocase "http://*" $readme]} {
        variable type "unknown"
    }
    # else   { # error }
    variable fileGroup [ipx::add_file_group -type readme {xilinx_readme} [ipx::current_core]]
    if {$type != "unknown"} {
        variable addedFile [ipx::add_file [::psi::util::path::relTo [get_property ROOT_DIRECTORY [ipx::current_core]] $readme false] $fileGroup]
    } else {
        variable addedFile [ipx::add_file $readme $fileGroup]
    }
    set_property type $type $addedFile
}

proc add_product_guide {guide} {
    if       {[string match -nocase "*.pdf"     $guide]} {
        variable type "pdf"
    } elseif {[string match -nocase "*.txt"     $guide] || [string match -nocase "*.md"     $guide]} {
        variable type "text"
    } elseif {[string match -nocase "*.html"    $guide] || [string match -nocase "*.htm"    $guide]} {
        variable type "html"
    } elseif {[string match -nocase "https://*" $guide] || [string match -nocase "http://*" $guide]} {
        variable type "unknown"
    }
    # else   { # error }
    variable fileGroup [ipx::add_file_group -type product_guide {xilinx_productguide} [ipx::current_core]]
    if {$type != "unknown"} {
        variable addedFile [ipx::add_file [::psi::util::path::relTo [get_property ROOT_DIRECTORY [ipx::current_core]] $guide false] $fileGroup]
    } else {
        variable addedFile [ipx::add_file $guide $fileGroup]
    }
    set_property type $type $addedFile
}

proc add_changelog {changelog} {
    if       {[string match -nocase "*.txt" $changelog] || [string match -nocase "*.md" $changelog]} {
        variable type "text"
    }
    # else   { # error }
    variable fileGroup [ipx::add_file_group -type version_info {xilinx_versioninformation} [ipx::current_core]]
    variable addedFile [ipx::add_file [::psi::util::path::relTo [get_property ROOT_DIRECTORY [ipx::current_core]] $changelog false] $fileGroup]
    set_property type $type $addedFile
}

proc add_constraints {constraints {used_in "default"}} {
    variable addedFiles [add_files -fileset constrs_1 -norecurse [file normalize $constraints]]
    if       {[string equal $used_in "default"]} {
        set_property used_in "synthesis implementation" $addedFiles
    } elseif {[string equal $used_in "synth"]} {
        set_property used_in "synthesis" $addedFiles
    } elseif {[string equal $used_in "impl"]} {
        set_property used_in "implementation" $addedFiles
    } elseif {[string equal $used_in "ooc"]} {
        set_property used_in "synthesis out_of_context" $addedFiles
    } elseif {[string equal $used_in "sim"]} {
        set_property used_in "simulation" $addedFiles
    }
    # ipx::merge_project_changes files [ipx::current_core]
}

proc add_driver_sources {driver} {
# TODO: Add driver
}

proc add_utility_files {utility_script} {
    if       {[string match -nocase "*.xit"  $utility_script]} {
        variable type "xit"
    } elseif {[string match -nocase "*.gtcl" $utility_script]} {
        variable type "GTCL"
    } elseif {[string match -nocase "*.tcl"  $utility_script]} {
        variable type "tclSource"
    } elseif {[string match -nocase "*.ttcl" $utility_script]} {
        variable type "ttcl"
    }
    # else   { # error }
    variable fileGroup [ipx::add_file_group -type utility {xilinx_utilityxitfiles} [ipx::current_core]]
    variable addedFile [ipx::add_file [::psi::util::path::relTo [get_property ROOT_DIRECTORY [ipx::current_core]] $utility_script false] $fileGroup]
    set_property type $type $addedFile
}

proc add_upgrade_tcl {upgrade_script previous_vlnv} {
    if       {[string match -nocase "*.tcl"  $upgrade_script]} {
        variable type "tclSource"
    }
    # else   { # error }
    variable fileGroup [ipx::add_file_group -type upgrade_script {xilinx_upgradescripts} [ipx::current_core]]
    variable addedFile [ipx::add_file [::psi::util::path::relTo [get_property ROOT_DIRECTORY [ipx::current_core]] $upgrade_script false] $fileGroup]
    set_property type $type $addedFile
    set_property PREVIOUS_VERSION_FOR_UPGRADE previous_vlnv [ipx::current_core]
}

# Parameters Procedures ###########################################################################
proc create_user_param {parameter format value {length 0}} {
# format = { long, float, bool, bitString, string}
    variable addedParam [ipx::add_user_parameter $parameter [ipx::current_core]]
    set_property value_resolve_type      user    $addedParam
    set_property value_format            $format $addedParam
    set_property value                   $value  $addedParam
    set_property value_bit_string_length $length $addedParam
    
}

proc set_param_validation {parameter type value} {
    variable userParam [ipx::get_user_parameters $parameter -of_objects [ipx::current_core]]
    variable valueFormat [get_property value_format $userParam]
    if {$valueFormat == "bool"} {
        error "ERROR - set_parameter_validation() not supported for bool parameters."
    }
    if {$type == "range"} { 
        if {$valueFormat == "bitString"} {
            error "ERROR - set_parameter_validation() not supported for bitString parameters."
        } elseif {$valueFormat == "string"} {
            error "ERROR - set_parameter_validation() not supported for string parameters."
        } elseif {$valueFormat == "long"} {
        set_property value_validation_type range_long  $userParam
        } elseif {$valueFormat == "float"} {
        set_property value_validation_type range_float $userParam
        }
        set_property value_validation_range_minimum [lindex $value 0] $userParam
        set_property value_validation_range_maximum [lindex $value 1] $userParam
    } elseif {$type == "list"} {
        if {$valueFormat == "bitString"} {
            #todo: add check for bitstring length!
        }
        set_property value_validation_type list    $userParam
        set_property value_validation_list $value  $userParam
    } elseif {$type == "pairs"} {
        if {$valueFormat == "bitString"} {
            #todo: add check for bitstring length!
        }
        set_property value_validation_type pairs   $userParam
        set_property value_validation_pairs $value $userParam
    } else {
        error "ERROR - set_parameter_validation() does not know type = ${type}."
    }

}

proc set_param_enablement_expr {parameter expression} {
    variable userParam [ipx::get_user_parameters $parameter -of_objects [ipx::current_core]]
    set_property enablement_tcl_expr "expr $expression" $userParam
    ipx::update_dependency $userParam
}

proc set_param_value_expr {parameter expression} {
    variable userParam [ipx::get_user_parameters $parameter -of_objects [ipx::current_core]]
    set_property value_tcl_expr "expr $expression" $userParam
    ipx::update_dependency $userParam
}

# Ports + Interfaces Procedures ###################################################################
proc create_bus_definition {bus} {
    # TODO: add this routine :D
}

proc import_bus_definition {definition} {
    update_ip_catalog -add_interface $definition -repo_path [get_property ROOT_DIRECTORY [ipx::current_core]]/interfaces
    update_ip_catalog -rebuild -repo_path [get_property ROOT_DIRECTORY [ipx::current_core]]
}

proc auto_infer_interface {name vlnv} {
    if {[string last ":" $vlnv] == -1} {
        set ifBusDef    [ipx::get_ipfiles -type busdef [ list *:${vlnv}:* *:${vlnv}\_int:*]]
        # set ifBusAbs    [ipx::get_ipfiles -type busabs [ list *:${vlnv}\_rtl:* *:${vlnv}:*]]
    } else {
        set ifBusDef    [ipx::get_ipfiles -type busdef *$vlnv*]
        # set ifBusAbs    [ipx::get_ipfiles -type busabs *$vlnv*]
    }
    if {[llength $ifBusDef] == 0} {
        error "ERROR - auto_infer_interface could not find an interface definition that matches $vlnv. Define a valid interface definition or use import_interface_definition if you forgot to import the definition."
    } elseif {[llength $ifBusDef] != 1} {
        error "ERROR - auto_infer_interface found multiple interface definitions that matches $vlnv (LIST: [get_property vlnv $ifBusDef]). Select a vlnv interface definition from the list and define the name accordingly!"
    }
    set ifBusDefVlnv    [get_property vlnv [lindex $ifBusDef 0]]
    # set IfBusAbsVlnv    [get_property vlnv [lindex $IfBusAbs 0]]
    ipx::infer_bus_interface [get_property name [ipx::get_ports $name]] $ifBusDefVlnv [ipx::current_core]
}

proc add_bus_interface {name vlnv interfaceMode portMaps} {
    if {[string last ":" $vlnv] == -1} {
        set ifBusDef    [ipx::get_ipfiles -type busdef [ list *:${vlnv}:* *:${vlnv}\_int:*]]
        set ifBusAbs    [ipx::get_ipfiles -type busabs [ list *:${vlnv}\_rtl:* *:${vlnv}:*]]
    } else {
        set ifBusDef    [ipx::get_ipfiles -type busdef *$vlnv*]
        set ifBusAbs    [ipx::get_ipfiles -type busabs *$vlnv*]
    }
    if {[llength $ifBusDef] == 0} {
        error "ERROR - add_bus_interface could not find an interface definition that matches $vlnv. Define a valid interface definition or use import_interface_definition if you forgot to import the definition."
    } elseif {[llength $ifBusDef] != 1} {
        error "ERROR - add_bus_interface found multiple interface definitions that matches $vlnv (LIST: [get_property vlnv $ifBusDef]). Select a vlnv interface definition from the list and define the name accordingly!"
    }
    set ifBusDefVlnv    [get_property vlnv [lindex $ifBusDef 0]]
    set ifBusAbsVlnv    [get_property vlnv [lindex $ifBusAbs 0]]
    set absPortList     [get_property name [ipx::get_bus_abstraction_ports -of_objects [lindex $ifBusAbs 0]]]     
    
    variable addedInterface [ipx::add_bus_interface $name [ipx::current_core]]
    set_property bus_type_vlnv          $ifBusDefVlnv   $addedInterface
    set_property abstraction_type_vlnv  $ifBusAbsVlnv   $addedInterface
    set_property interface_mode         $interfaceMode  $addedInterface

    foreach portMap $portMaps {
        set physicalName    [lindex $portMap 0]
        set abstractionName [lindex $portMap 1]
        if {[lsearch -exact $absPortList $abstractionName] == -1} { 
            error "ERROR - add_bus_interface found no abstraction port that is named $abstractionName (LIST: $absPortList). Select a abstraction port from the list and define the name accordingly!"
        }
        set_property physical_name $physicalName [ipx::add_port_map $abstractionName $addedInterface]
    }
}

proc add_axi_interface {name} {
    ipx::infer_bus_interface [get_property name [ipx::get_ports $name]] xilinx.com:interface:aximm:1.0 [ipx::current_core]
}

proc add_axis_interface {name} {
    ipx::infer_bus_interface [get_property name [ipx::get_ports $name]] xilinx.com:interface:axis:1.0 [ipx::current_core]
}

proc add_clock_interface {name} {
    ipx::infer_bus_interface [get_property name [ipx::get_ports $name]] xilinx.com:signal:clock:1.0 [ipx::current_core]
}

proc add_clockenable_interface {name} {
    ipx::infer_bus_interface [get_property name [ipx::get_ports $name]] xilinx.com:signal:clockenable_rtl:1.0 [ipx::current_core]
}

proc add_reset_interface {name {polarity ACTIVE_HIGH}} {
    variable addedInterface [ipx::infer_bus_interface [get_property name [ipx::get_ports $name]] xilinx.com:signal:reset:1.0 [ipx::current_core]]
    set_property value $polarity [ipx::add_bus_parameter POLARITY $addedInterface]
}

proc add_interrupt_interface {name {sensitivity LEVEL_HIGH}} {
    variable addedInterface [ipx::infer_bus_interface [get_property name [ipx::get_ports $name]] xilinx.com:signal:interrupt:1.0 [ipx::current_core]]
    # LEVEL_HIGH LEVEL_LOW EDGE_RISING EDGE_FALLING
    set_property value $sensitivity [ipx::add_bus_parameter SENSITIVITY $addedInterface] 
}

proc set_associated_interface_clock {interface clk} {
        if {$interface == "ALL"} {
            ipx::associate_bus_interfaces -busif [get_property name [ipx::get_bus_interfaces -of_objects  [ipx::current_core]]] -clock $clk [ipx::current_core]
        } else {
            ipx::associate_bus_interfaces -busif $intf -clock $clk [ipx::current_core]
        }
}

proc set_associated_clock_reset {clks reset} {
    foreach clk $clks {
        ipx::associate_bus_interfaces -clock $clk -reset $reset [ipx::current_core]
	}
}

proc set_interface_enablement_expr {interface expression} {
    set_property enablement_dependency $expression [ipx::get_bus_interfaces $interface -of_objects [ipx::current_core]]
}

proc set_port_enablement_expr {port expression} {
    set_property enablement_dependency $expression [ipx::get_ports $port -of_objects [ipx::current_core]]
}


# Adressing + Memory Procedures ###################################################################

# GUI Procedures ##################################################################################
proc gui_add_page {page {tooltip ""}} {
    variable CurrentGuiParent
    variable CurrentGuiPage [ipgui::add_page -name $page -component [ipx::current_core] -parent $CurrentGuiParent -display_name $page]
    set_property tooltip $tooltip $CurrentGuiPage
    set CurrentGuiParent $CurrentGuiPage
}

proc gui_add_group {group layout {tooltip ""}} {
    variable CurrentGuiParent
    variable CurrentGuiPage [ipgui::add_group -name $group -component [ipx::current_core] -parent $CurrentGuiParent -display_name $group]
    set_property layout  $layout  $CurrentGuiPage
    set_property tooltip $tooltip $CurrentGuiPage
    set CurrentGuiParent $CurrentGuiPage
}

proc gui_add_param {name display_name} {
    variable CurrentGuiParent
    variable CurrentGuiParam 
    set CurrentGuiParam [ipgui::add_param -name $name -component [ipx::current_core] -parent $CurrentGuiParent]
    set_property display_name $display_name $CurrentGuiParam
}

proc gui_set_param_tooltip {tooltip} {
    variable CurrentGuiParam 
    set_property tooltip      $tooltip      $CurrentGuiParam
}

proc gui_show_param_range {show_range} {
    variable CurrentGuiParam 
    set_property show_range   $show_range   $CurrentGuiParam
}

proc gui_set_param_widget {widget {layout "vertical"}} {
    variable CurrentGuiParam 
    set_property widget       $widget       $CurrentGuiParam
    set_property layout       $layout       $CurrentGuiParam
}

proc gui_add_text {name text} {
    variable CurrentGuiParent
    ipgui::add_static_text -name $name -component [ipx::current_core] -parent $CurrentGuiParent -text $text
}

proc gui_change_parent {{name "root"}} {
    variable CurrentGuiParent
    if {[string match -nocase "root" $name]} {
        set CurrentGuiParent nullptr
    } else {
        set CurrentGuiParent [ipgui::get_groupspec -name $name -component [ipx::current_core] -quiet]
        if {$CurrentGuiParent == ""} {
            set CurrentGuiParent [ipgui::get_pagespec -name $name -component [ipx::current_core] -quiet]
        }
    }
}


	
#	#Source GUI support TCL scripts
#	variable GuiSupportTcl
#	foreach script $GuiSupportTcl {
#		set ::script $script
#		namespace eval "::" {
#			source "../$script"
#		}
#	}
#
#    # Add Bus Interface
#    puts "*** Add Bus Interface ***"
#	variable AddBusInterfaces
#    foreach busIf $AddBusInterfaces {      
#		set IfDefinition    [dict get $busIf DEFI]
#		set IfName          [dict get $busIf NAME]
#		set IfMode          [dict get $busIf MODE]
#		set IfDescription   [dict get $busIf DESCRIPTION]
#		set IfPortMaps      [dict get $busIf PORT_MAPS]
#        set LastDpPosition  [string last ":" $IfDefinition]
#        set LastRtlPosition [string last "_rtl" $IfDefinition]
#        set DefStringLength [string length $IfDefinition]
#        if {$LastDpPosition == -1} {
#            if {[expr {$DefStringLength - $LastRtlPosition - 4}] == 0} {
#                set IfDefinition [string replace $IfDefinition $LastRtlPosition [expr {$DefStringLength - 1}] ""]
#            }
#            set IfBusDef    [ipx::get_ipfiles -type busdef *:$IfDefinition:*]
#            set IfBusAbs    [ipx::get_ipfiles -type busabs *:$IfDefinition\_rtl:*]
#        } else {
#            if {[expr {$LastDpPosition - $LastRtlPosition - 4}] == 0} {
#                set IfDefinition [string replace $IfDefinition $LastRtlPosition [expr {$LastDpPosition - 1}] ""]
#                set LastDpPosition  [expr {$LastDpPosition - 4}]
#            }
#            set IfBusDef    [ipx::get_ipfiles -type busdef $IfDefinition]
#            set IfBusAbs    [ipx::get_ipfiles -type busabs [string replace $IfDefinition $LastDpPosition $LastDpPosition "_rtl:"]]
#        }
#        if {[llength $IfBusDef] == 0} {
#            puts "ERROR: Could not find a interface definition that contains $IfDefinition. Define a valid interface definition or use import_interface_definition if you forgot to import the definition."
#            return
#        } elseif {[llength $IfBusDef] != 1} {
#            error "ERROR: Found multiple interface definitions that contain $IfDefinition (LIST: [get_property vlnv $IfBusDef]). Select a vlnv interface definition from the list and define the name accordingly!"
#            return
#        }
#        set IfBusDefVlnv    [get_property vlnv [lindex $IfBusDef 0]]
#		set IfBusAbsVlnv    [get_property vlnv [lindex $IfBusAbs 0]]
#        set AbsPortList     [get_property name [ipx::get_bus_abstraction_ports -of_objects [lindex $IfBusAbs 0]]]     
#        
#        ipx::add_bus_interface $IfName                      [ipx::current_core]
#        set_property abstraction_type_vlnv $IfBusAbsVlnv    [ipx::get_bus_interfaces $IfName -of_objects [ipx::current_core]]
#        set_property bus_type_vlnv $IfBusDefVlnv            [ipx::get_bus_interfaces $IfName -of_objects [ipx::current_core]]
#        set_property interface_mode $IfMode                 [ipx::get_bus_interfaces $IfName -of_objects [ipx::current_core]]
#        set_property description $IfDescription             [ipx::get_bus_interfaces $IfName -of_objects [ipx::current_core]]
#
#        foreach portMap $IfPortMaps {
#            set PhysicalName [lindex $portMap 0]
#            set AbstractionName [lindex $portMap 1]
#            if {[lsearch -exact $AbsPortList $AbstractionName] == -1} { 
#                error "ERROR: Found no abstraction port that is named $AbstractionName (LIST: $AbsPortList). Select a abstraction port from the list and define the name accordingly!"
#                return
#            }
#            ipx::add_port_map $AbstractionName [ipx::get_bus_interfaces $IfName -of_objects [ipx::current_core]]
#            set_property physical_name $PhysicalName [ipx::get_port_maps $AbstractionName -of_objects [ipx::get_bus_interfaces $IfName -of_objects [ipx::current_core]]]
#        }
#    }
#    
#	
#
#
#	#Add drivers if required
#	variable DriverDir
#	variable DriverFiles
#	variable fileLoc
#	variable XparParameters
#	puts "*** Add drivers ***"
#	if {$DriverDir != "None"} {
#		#Initialize Driver
#		ipx::add_file_group -type software_driver {} [ipx::current_core]		
#		
#		#Create directoreis if required
#		file mkdir $DriverDir/data
#		file mkdir $DriverDir/src
#		
#		#.MDD File
#		psi::util::string::copyAndReplaceTags "$fileLoc/Snippets/driver/snippet.mdd" $DriverDir/data/$IpName\.mdd [dict create <IP_NAME> $IpName]
#		set MddPathRel [psi::util::path::relTo $targetDir $DriverDir/data/$IpName\.mdd false]
#		ipx::add_file $MddPathRel [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]
#		set_property type mdd [ipx::get_files $MddPathRel -of_objects [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]]
#		
#		#.TCL File
#		set paramList ""
#		foreach param $XparParameters {
#			set paramList "$paramList \"$param\""
#		}
#		set paramList [string trim $paramList]
#		psi::util::string::copyAndReplaceTags "$fileLoc/Snippets/driver/snippet.tcl" $DriverDir/data/$IpName\.tcl [dict create <IP_NAME> $IpName <PARAM_LIST> $paramList]
#		set TclPathRel [psi::util::path::relTo $targetDir $DriverDir/data/$IpName\.tcl false]
#		ipx::add_file $TclPathRel [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]
#		set_property type tclSource [ipx::get_files $TclPathRel -of_objects [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]]
#		
#		#Makefile
#		psi::util::string::copyAndReplaceTags "$fileLoc/Snippets/driver/Makefile" $DriverDir/src/Makefile [dict create <IP_NAME> $IpName]
#		set MakePathRel [psi::util::path::relTo $targetDir $DriverDir/src/Makefile false]
#		ipx::add_file $MakePathRel [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]
#		set_property type unknown [ipx::get_files $MakePathRel -of_objects [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]]
#
#		#Add driver files		
#		foreach file $DriverFiles {
#			set FilePathRel [psi::util::path::relTo $targetDir $DriverDir/$file false]
#			ipx::add_file $FilePathRel [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]
#			set_property type cSource [ipx::get_files $FilePathRel -of_objects [ipx::get_file_groups xilinx_softwaredriver -of_objects [ipx::current_core]]]
#		}
#	}
#	
#	
#
#	#Add GUI Support TCL files to generated file (there is no clean way to do this during packaging)
#	variable GuiSupportTcl
#	if {[llength $GuiSupportTcl] > 0} {
#		#Read file
#		set f [open [glob ../xgui/$IpName*.tcl] "r"]
#		set content [read $f]
#		close $f
#		
#		#Add line
#		set f [open [glob ../xgui/$IpName*.tcl] "w+"]
#		foreach script $GuiSupportTcl {
#			puts -nonewline $f {source [file join [file dirname [file dirname [info script]]]}
#			puts $f " $script]\n"
#		}
#		puts $f $content
#		close $f		
#	}
#	
#	puts "*** DONE ***"
