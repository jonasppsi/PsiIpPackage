###################################################################################################
# Include PSI packaging commands
###################################################################################################
source ../../PsiIpPackage.tcl
namespace import -force psi::ip_package::2020_1::*

###################################################################################################
# Init
###################################################################################################
set IpiFolder           "./../ip_repo/ipi/DummyIpi_2020_1"
set TopEntityFile       "./../hdl/dummy_ipi.vhd"

create_package_project  $TopEntityFile $IpiFolder

###################################################################################################
# Identification
###################################################################################################
set_vendor              "psi.ch"
set_library             "IpPackage"
set_name                "IpPackage_2020_1_tb"
set_version             1.0
set_core_revision       "auto"
set_display_name        "IP Package 2020.1 Testbench"
set_description         "This is a dummy IPI for testing the PsiIpPackager."
set_vendor_display_name "Paul Scherrer Institute"
set_company_url         "http://www.psi.ch"
set_taxonomy            "/PSI"

###################################################################################################
# Compartibility
###################################################################################################
# set_supported_families        {artix7 Production zynq Beta}
enable_auto_familiy_support     level_1
set_unsupported_simulators      {riviera activehdl vcs xsim ies xcelium}

###################################################################################################
# File Groups
###################################################################################################
copy_files              [list   "D:/Lib/lib/FW/VHDL/en_cl/hdl/en_cl_base_pkg.vhd" \
                                "D:/Lib/lib/FW/VHDL/en_cl/hdl/en_cl_rom_fifo.vhd" ] \
                        "$IpiFolder/hdl/lib"

add_source_files        [list "./../hdl/file2.vhd" "D:/Lib/lib/FW/VHDL/en_cl/hdl/en_cl_base_pkg.vhd"] "VHDL 2008"
add_source_files        "./../hdl/test.v"       "Verilog"

add_logo                "./../doc/dummy_logo.png"
add_readme              "./../doc/dummy_readme.pdf"
add_product_guide       "https://psi.ch"
add_changelog           "./../doc/dummy_changelog.txt"

add_constraints         "./../constraints/ooc.sdc"    ooc
add_constraints         "./../constraints/synth.tcl"  synth
add_constraints         "./../constraints/impl.xdc"   impl

add_utility_files       "./../util/any_util.tcl"

add_upgrade_tcl         "./../util/ip_upgrade.tcl" {0.1}

###################################################################################################
# Customization Paramenters
###################################################################################################

create_user_param           "TestLong"          "long"          1
create_user_param           "TestFloat"         "float"         1.5
create_user_param           "TestBool"          "bool"          true
create_user_param           "TestBitString"     "bitString"     0x1F    5
create_user_param           "TestString"        "string"        "HALLO"

set_param_validation        "TestLong"          "range"         {0 10}

set_param_validation        "TestFloat"         "list"          {1.0 1.5 2.0 2.5}

set_param_validation        "TestBitString"     "pairs"         {A "01010" B "10101"}

set_param_enablement_expr   "TestLong"          "\$TestBool == true"
set_param_enablement_expr   "TestFloat"         "\$TestBool == false"

set_param_value_expr        "TestString"        "\$TestLong * 10"

###################################################################################################
# Ports and Interfaces
###################################################################################################

auto_infer_interface            "Clk"               "clock"
auto_infer_interface            "Rst"               "reset"
auto_infer_interface            "S_Axi_*"           "aximm"
auto_infer_interface            "S_Axis_*"          "axis"
auto_infer_interface            "Axi_Clk"           "xilinx.com:signal:clock:1.0"
auto_infer_interface            "Axis_ResetN"       "xilinx.com:signal:reset:1.0"
add_axi_interface               "M_Axi_*"
add_axis_interface              "M_Axis_*"
add_reset_interface             "Axi_ResetN"        "ACTIVE_LOW"
add_clock_interface             "Axis_Clk"
add_interrupt_interface         "Interrupt"
add_bus_interface               "UART" \
                                "uart" \
                                "Master" \
                                [list \
                                    {"Uart_Tx" "TxD"} \
                                    {"Uart_Rx" "RxD"} ]
                                
set_associated_interface_clock  "M_Axis"            "Axis_Clk"
set_associated_clock_reset      "Axis_Clk"          "Axis_ResetN"
      
set_interface_enablement_expr   "*_Axis"            "\$TestLong >= 5"
set_port_enablement_expr        "Uart_Tx"           "\$TestBool == false"

###################################################################################################
# Adressing and Memory
###################################################################################################

###################################################################################################
# Customization GUI
###################################################################################################
gui_add_page                    "Page 1"                "Tooltip Page 1"
    gui_add_group               "Group 11"  "vertical"  "Tooltip Group 1"
        gui_add_param           "TestLong"  "Random Long"
        gui_set_param_tooltip   "This is a dummy Long"
        gui_show_param_range    "false"

gui_change_parent               "Page 1"
    gui_add_group               "Group 2"   "vertical" "Tooltip Group 2"

        gui_add_param           "TestBool"  "Random Boolean"
        gui_set_param_tooltip   "This is a dummy Boolean"

    gui_change_parent           "Group 11"
        gui_add_param           "TestString"  "Random String"
        gui_set_param_tooltip   "This is a dummy String"

gui_change_parent               "Page 1"
    gui_add_page                "Page 2"    "Tooltip Page 2"
    gui_add_param               "TestBitString"  "Random BitString"
    gui_set_param_tooltip       "This is a dummy BitString"
    gui_set_param_widget        "radioGroup" "horizontal"
    
    gui_add_text                "TestText"  "this is a dummy Text"

###################################################################################################
# Review and Package
###################################################################################################
save_package_project