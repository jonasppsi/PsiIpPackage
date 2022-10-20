###################################################################################################
## Copyright (c) 2021 Enclustra GmbH, Switzerland (info@enclustra.com)
###################################################################################################

###################################################################################################
# Include PSI packaging commands
###################################################################################################
source ../../PsiIpPackage.tcl
namespace import -force psi::ip_package::2017_2_1::*

###################################################################################################
# General Information
###################################################################################################
set IP_VENDOR       "psi.ch"
set IP_LIBRARY      "IpPackage"
set IP_NAME         "IpPackage_2017_2_1_tb"
set IP_VERSION      0.1
set IP_REVISION     "auto"
set IP_DESCIRPTION  "This is a dummy IPI for testing the PsiIpPackager."
set IP_VENDOR_DISP  "Paul Scherrer Institute"
set IP_VENDOR_URL   "http://www.psi.ch"
set IP_TOP_ENTITY   "dummy_ipi"

###################################################################################################
# Init IP Project
###################################################################################################
init                $IP_NAME $IP_VERSION $IP_REVISION $IP_LIBRARY
set_description     $IP_DESCIRPTION
set_vendor_short    $IP_VENDOR
set_vendor          $IP_VENDOR_DISP
set_vendor_url      $IP_VENDOR_URL
set_top_entity      $IP_TOP_ENTITY

###################################################################################################
# Add Source Files
###################################################################################################
add_sources_relative { \
    ../hdl/dummy_ipi.vhd \
    } NONE "VHDL"

###################################################################################################
# GUI Parameters
###################################################################################################
gui_add_page "Configuration"

gui_create_parameter "Clk_FreqHz_g" "Clock Frequency (Hz):"
gui_add_parameter

gui_create_parameter "M_Axi_DataWidth_g" "Master AXI Data Width:"
gui_parameter_set_widget_dropdown_list {32 64 128 256}
gui_add_parameter

gui_create_parameter "M_Axi_AddrWidth_g" "Master AXI Address Width:"
gui_parameter_set_range 1 32
gui_add_parameter

gui_create_parameter "S_Axi_DataWidth_g" "Slave AXI Data Width:"
gui_parameter_set_widget_dropdown_list {32 64 128 256}
gui_add_parameter

gui_create_parameter "S_Axi_AddrWidth_g" "Slave AXI Address Width:"
gui_parameter_set_range 1 32
gui_add_parameter

gui_create_parameter "M_Axis_TDataWidth_g" "Master AXI4-Stream TData Width:"
gui_parameter_set_widget_dropdown_list {8 16 32 64 128 256}
gui_add_parameter

gui_create_parameter "M_Axis_TUserWidth_g" "Master AXI4-Stream TUser Width:"
gui_parameter_set_range 0 256
gui_add_parameter

gui_create_parameter "S_Axis_TDataWidth_g" "Slave AXI4-Stream TData Width:"
gui_parameter_set_widget_dropdown_list {8 16 32 64 128 256}
gui_add_parameter

gui_create_parameter "S_Axis_TUserWidth_g" "Slave AXI4-Stream TUser Width:"
gui_parameter_set_range 0 256
gui_add_parameter

###################################################################################################
# Interfaces
###################################################################################################
add_clock_in_interface  "Clk"
add_reset_in_interface  "Rst" "positive"

add_clock_in_interface  "Axi_Clk"
add_reset_in_interface  "Axi_ResetN" "negative"

add_clock_in_interface  "Axis_Clk"
add_reset_in_interface  "Axis_ResetN" "negative"

set_interface_clock     "M_Axi" "Axi_Clk"
set_interface_clock     "S_Axi" "Axi_Clk"

set_interface_clock     "M_Axis" "Axis_Clk"
set_interface_clock     "S_Axis" "Axis_Clk"

add_bus_interface       "xilinx.com:interface:uart:1.0" \
                        "Uart" \
                        "master" \
                        "Uart master interface" \
                        {{"Uart_Rx" "RxD"} \
                         {"Uart_Tx" "TxD"} }

###################################################################################################
# Conditional Interfaces
###################################################################################################
# TBD...

###################################################################################################
# Package Core
###################################################################################################
set TargetDir "./../ip_repo/ipi/DummyIpi_2017_2_1"
#                               Edit    Synth   Part
package_ip $TargetDir           true   true    xczu4ev-sfvc784-1-i
