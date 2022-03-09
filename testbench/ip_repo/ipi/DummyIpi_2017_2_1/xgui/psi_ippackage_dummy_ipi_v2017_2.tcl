# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Configuration [ipgui::add_page $IPINST -name "Configuration"]
  ipgui::add_param $IPINST -name "Clk_FreqHz_g" -parent ${Configuration}
  ipgui::add_param $IPINST -name "M_Axi_DataWidth_g" -parent ${Configuration} -widget comboBox
  ipgui::add_param $IPINST -name "M_Axi_AddrWidth_g" -parent ${Configuration}
  ipgui::add_param $IPINST -name "S_Axi_DataWidth_g" -parent ${Configuration} -widget comboBox
  ipgui::add_param $IPINST -name "S_Axi_AddrWidth_g" -parent ${Configuration}
  ipgui::add_param $IPINST -name "M_Axis_TDataWidth_g" -parent ${Configuration} -widget comboBox
  ipgui::add_param $IPINST -name "M_Axis_TUserWidth_g" -parent ${Configuration}
  ipgui::add_param $IPINST -name "S_Axis_TDataWidth_g" -parent ${Configuration} -widget comboBox
  ipgui::add_param $IPINST -name "S_Axis_TUserWidth_g" -parent ${Configuration}


}

proc update_PARAM_VALUE.Clk_FreqHz_g { PARAM_VALUE.Clk_FreqHz_g } {
	# Procedure called to update Clk_FreqHz_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Clk_FreqHz_g { PARAM_VALUE.Clk_FreqHz_g } {
	# Procedure called to validate Clk_FreqHz_g
	return true
}

proc update_PARAM_VALUE.M_Axi_AddrWidth_g { PARAM_VALUE.M_Axi_AddrWidth_g } {
	# Procedure called to update M_Axi_AddrWidth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_Axi_AddrWidth_g { PARAM_VALUE.M_Axi_AddrWidth_g } {
	# Procedure called to validate M_Axi_AddrWidth_g
	return true
}

proc update_PARAM_VALUE.M_Axi_DataWidth_g { PARAM_VALUE.M_Axi_DataWidth_g } {
	# Procedure called to update M_Axi_DataWidth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_Axi_DataWidth_g { PARAM_VALUE.M_Axi_DataWidth_g } {
	# Procedure called to validate M_Axi_DataWidth_g
	return true
}

proc update_PARAM_VALUE.M_Axis_TDataWidth_g { PARAM_VALUE.M_Axis_TDataWidth_g } {
	# Procedure called to update M_Axis_TDataWidth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_Axis_TDataWidth_g { PARAM_VALUE.M_Axis_TDataWidth_g } {
	# Procedure called to validate M_Axis_TDataWidth_g
	return true
}

proc update_PARAM_VALUE.M_Axis_TUserWidth_g { PARAM_VALUE.M_Axis_TUserWidth_g } {
	# Procedure called to update M_Axis_TUserWidth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_Axis_TUserWidth_g { PARAM_VALUE.M_Axis_TUserWidth_g } {
	# Procedure called to validate M_Axis_TUserWidth_g
	return true
}

proc update_PARAM_VALUE.S_Axi_AddrWidth_g { PARAM_VALUE.S_Axi_AddrWidth_g } {
	# Procedure called to update S_Axi_AddrWidth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_Axi_AddrWidth_g { PARAM_VALUE.S_Axi_AddrWidth_g } {
	# Procedure called to validate S_Axi_AddrWidth_g
	return true
}

proc update_PARAM_VALUE.S_Axi_DataWidth_g { PARAM_VALUE.S_Axi_DataWidth_g } {
	# Procedure called to update S_Axi_DataWidth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_Axi_DataWidth_g { PARAM_VALUE.S_Axi_DataWidth_g } {
	# Procedure called to validate S_Axi_DataWidth_g
	return true
}

proc update_PARAM_VALUE.S_Axis_TDataWidth_g { PARAM_VALUE.S_Axis_TDataWidth_g } {
	# Procedure called to update S_Axis_TDataWidth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_Axis_TDataWidth_g { PARAM_VALUE.S_Axis_TDataWidth_g } {
	# Procedure called to validate S_Axis_TDataWidth_g
	return true
}

proc update_PARAM_VALUE.S_Axis_TUserWidth_g { PARAM_VALUE.S_Axis_TUserWidth_g } {
	# Procedure called to update S_Axis_TUserWidth_g when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_Axis_TUserWidth_g { PARAM_VALUE.S_Axis_TUserWidth_g } {
	# Procedure called to validate S_Axis_TUserWidth_g
	return true
}


proc update_MODELPARAM_VALUE.Clk_FreqHz_g { MODELPARAM_VALUE.Clk_FreqHz_g PARAM_VALUE.Clk_FreqHz_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Clk_FreqHz_g}] ${MODELPARAM_VALUE.Clk_FreqHz_g}
}

proc update_MODELPARAM_VALUE.M_Axi_DataWidth_g { MODELPARAM_VALUE.M_Axi_DataWidth_g PARAM_VALUE.M_Axi_DataWidth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_Axi_DataWidth_g}] ${MODELPARAM_VALUE.M_Axi_DataWidth_g}
}

proc update_MODELPARAM_VALUE.M_Axi_AddrWidth_g { MODELPARAM_VALUE.M_Axi_AddrWidth_g PARAM_VALUE.M_Axi_AddrWidth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_Axi_AddrWidth_g}] ${MODELPARAM_VALUE.M_Axi_AddrWidth_g}
}

proc update_MODELPARAM_VALUE.S_Axi_DataWidth_g { MODELPARAM_VALUE.S_Axi_DataWidth_g PARAM_VALUE.S_Axi_DataWidth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_Axi_DataWidth_g}] ${MODELPARAM_VALUE.S_Axi_DataWidth_g}
}

proc update_MODELPARAM_VALUE.S_Axi_AddrWidth_g { MODELPARAM_VALUE.S_Axi_AddrWidth_g PARAM_VALUE.S_Axi_AddrWidth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_Axi_AddrWidth_g}] ${MODELPARAM_VALUE.S_Axi_AddrWidth_g}
}

proc update_MODELPARAM_VALUE.M_Axis_TDataWidth_g { MODELPARAM_VALUE.M_Axis_TDataWidth_g PARAM_VALUE.M_Axis_TDataWidth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_Axis_TDataWidth_g}] ${MODELPARAM_VALUE.M_Axis_TDataWidth_g}
}

proc update_MODELPARAM_VALUE.M_Axis_TUserWidth_g { MODELPARAM_VALUE.M_Axis_TUserWidth_g PARAM_VALUE.M_Axis_TUserWidth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_Axis_TUserWidth_g}] ${MODELPARAM_VALUE.M_Axis_TUserWidth_g}
}

proc update_MODELPARAM_VALUE.S_Axis_TDataWidth_g { MODELPARAM_VALUE.S_Axis_TDataWidth_g PARAM_VALUE.S_Axis_TDataWidth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_Axis_TDataWidth_g}] ${MODELPARAM_VALUE.S_Axis_TDataWidth_g}
}

proc update_MODELPARAM_VALUE.S_Axis_TUserWidth_g { MODELPARAM_VALUE.S_Axis_TUserWidth_g PARAM_VALUE.S_Axis_TUserWidth_g } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_Axis_TUserWidth_g}] ${MODELPARAM_VALUE.S_Axis_TUserWidth_g}
}

