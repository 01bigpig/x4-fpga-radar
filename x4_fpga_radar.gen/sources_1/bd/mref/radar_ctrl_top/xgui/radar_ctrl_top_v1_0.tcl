# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BURST_BYTE_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CLK_DIV_BURST" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PIF_1D_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PIF_DONE_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PIF_RAMSEL_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PIF_RESET_CNTR_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PIF_TRX_START_ADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "POLL_TIMEOUT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WR_WAIT_CYCLES" -parent ${Page_0}


}

proc update_PARAM_VALUE.BURST_BYTE_COUNT { PARAM_VALUE.BURST_BYTE_COUNT } {
	# Procedure called to update BURST_BYTE_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BURST_BYTE_COUNT { PARAM_VALUE.BURST_BYTE_COUNT } {
	# Procedure called to validate BURST_BYTE_COUNT
	return true
}

proc update_PARAM_VALUE.CLK_DIV_BURST { PARAM_VALUE.CLK_DIV_BURST } {
	# Procedure called to update CLK_DIV_BURST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_DIV_BURST { PARAM_VALUE.CLK_DIV_BURST } {
	# Procedure called to validate CLK_DIV_BURST
	return true
}

proc update_PARAM_VALUE.PIF_1D_ADDR { PARAM_VALUE.PIF_1D_ADDR } {
	# Procedure called to update PIF_1D_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PIF_1D_ADDR { PARAM_VALUE.PIF_1D_ADDR } {
	# Procedure called to validate PIF_1D_ADDR
	return true
}

proc update_PARAM_VALUE.PIF_DONE_ADDR { PARAM_VALUE.PIF_DONE_ADDR } {
	# Procedure called to update PIF_DONE_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PIF_DONE_ADDR { PARAM_VALUE.PIF_DONE_ADDR } {
	# Procedure called to validate PIF_DONE_ADDR
	return true
}

proc update_PARAM_VALUE.PIF_RAMSEL_ADDR { PARAM_VALUE.PIF_RAMSEL_ADDR } {
	# Procedure called to update PIF_RAMSEL_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PIF_RAMSEL_ADDR { PARAM_VALUE.PIF_RAMSEL_ADDR } {
	# Procedure called to validate PIF_RAMSEL_ADDR
	return true
}

proc update_PARAM_VALUE.PIF_RESET_CNTR_ADDR { PARAM_VALUE.PIF_RESET_CNTR_ADDR } {
	# Procedure called to update PIF_RESET_CNTR_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PIF_RESET_CNTR_ADDR { PARAM_VALUE.PIF_RESET_CNTR_ADDR } {
	# Procedure called to validate PIF_RESET_CNTR_ADDR
	return true
}

proc update_PARAM_VALUE.PIF_TRX_START_ADDR { PARAM_VALUE.PIF_TRX_START_ADDR } {
	# Procedure called to update PIF_TRX_START_ADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PIF_TRX_START_ADDR { PARAM_VALUE.PIF_TRX_START_ADDR } {
	# Procedure called to validate PIF_TRX_START_ADDR
	return true
}

proc update_PARAM_VALUE.POLL_TIMEOUT { PARAM_VALUE.POLL_TIMEOUT } {
	# Procedure called to update POLL_TIMEOUT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.POLL_TIMEOUT { PARAM_VALUE.POLL_TIMEOUT } {
	# Procedure called to validate POLL_TIMEOUT
	return true
}

proc update_PARAM_VALUE.WR_WAIT_CYCLES { PARAM_VALUE.WR_WAIT_CYCLES } {
	# Procedure called to update WR_WAIT_CYCLES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WR_WAIT_CYCLES { PARAM_VALUE.WR_WAIT_CYCLES } {
	# Procedure called to validate WR_WAIT_CYCLES
	return true
}


proc update_MODELPARAM_VALUE.CLK_DIV_BURST { MODELPARAM_VALUE.CLK_DIV_BURST PARAM_VALUE.CLK_DIV_BURST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLK_DIV_BURST}] ${MODELPARAM_VALUE.CLK_DIV_BURST}
}

proc update_MODELPARAM_VALUE.BURST_BYTE_COUNT { MODELPARAM_VALUE.BURST_BYTE_COUNT PARAM_VALUE.BURST_BYTE_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BURST_BYTE_COUNT}] ${MODELPARAM_VALUE.BURST_BYTE_COUNT}
}

proc update_MODELPARAM_VALUE.PIF_RESET_CNTR_ADDR { MODELPARAM_VALUE.PIF_RESET_CNTR_ADDR PARAM_VALUE.PIF_RESET_CNTR_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PIF_RESET_CNTR_ADDR}] ${MODELPARAM_VALUE.PIF_RESET_CNTR_ADDR}
}

proc update_MODELPARAM_VALUE.PIF_TRX_START_ADDR { MODELPARAM_VALUE.PIF_TRX_START_ADDR PARAM_VALUE.PIF_TRX_START_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PIF_TRX_START_ADDR}] ${MODELPARAM_VALUE.PIF_TRX_START_ADDR}
}

proc update_MODELPARAM_VALUE.PIF_DONE_ADDR { MODELPARAM_VALUE.PIF_DONE_ADDR PARAM_VALUE.PIF_DONE_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PIF_DONE_ADDR}] ${MODELPARAM_VALUE.PIF_DONE_ADDR}
}

proc update_MODELPARAM_VALUE.PIF_RAMSEL_ADDR { MODELPARAM_VALUE.PIF_RAMSEL_ADDR PARAM_VALUE.PIF_RAMSEL_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PIF_RAMSEL_ADDR}] ${MODELPARAM_VALUE.PIF_RAMSEL_ADDR}
}

proc update_MODELPARAM_VALUE.PIF_1D_ADDR { MODELPARAM_VALUE.PIF_1D_ADDR PARAM_VALUE.PIF_1D_ADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PIF_1D_ADDR}] ${MODELPARAM_VALUE.PIF_1D_ADDR}
}

proc update_MODELPARAM_VALUE.WR_WAIT_CYCLES { MODELPARAM_VALUE.WR_WAIT_CYCLES PARAM_VALUE.WR_WAIT_CYCLES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WR_WAIT_CYCLES}] ${MODELPARAM_VALUE.WR_WAIT_CYCLES}
}

proc update_MODELPARAM_VALUE.POLL_TIMEOUT { MODELPARAM_VALUE.POLL_TIMEOUT PARAM_VALUE.POLL_TIMEOUT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.POLL_TIMEOUT}] ${MODELPARAM_VALUE.POLL_TIMEOUT}
}

