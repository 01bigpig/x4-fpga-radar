## SPI SCK  == J10 Pin#3
set_property PACKAGE_PIN W19 [get_ports spi_sck]
set_property IOSTANDARD LVCMOS33 [get_ports spi_sck]

## SPI MOSI == J10 Pin#4
set_property PACKAGE_PIN W18 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports spi_mosi]

## SPI MISO == J10 Pin#5
set_property PACKAGE_PIN R14 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports spi_miso]

## SPI CS   == J10 Pin#6
set_property PACKAGE_PIN P14 [get_ports spi_cs]
set_property IOSTANDARD LVCMOS33 [get_ports spi_cs]






create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list x4_bd_i/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[7]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[8]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[9]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[10]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[11]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[12]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[13]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[14]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_rx16_dbg[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 8 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif1B_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif1B_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif1B_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif1B_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif1B_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif1B_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif1B_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif1B_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_addr_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_addr_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_addr_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_addr_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_addr_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_addr_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_addr_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_addr_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_data_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_data_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_data_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_data_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_data_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_data_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_data_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_data_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 7 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_cnt_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_cnt_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_cnt_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_cnt_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_cnt_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_cnt_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/coeff_cnt_dbg[6]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[7]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[8]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[9]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[10]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[11]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[12]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[13]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[14]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/last_tx16_dbg[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif0F_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif0F_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif0F_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif0F_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif0F_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif0F_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif0F_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif0F_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif73_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif73_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif73_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif73_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif73_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif73_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif73_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif73_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif78_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif78_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif78_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif78_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif78_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif78_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif78_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif78_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 8 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif4A_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif4A_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif4A_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif4A_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif4A_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif4A_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif4A_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif4A_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 8 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_xosc_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_xosc_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_xosc_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_xosc_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_xosc_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_xosc_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_xosc_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_xosc_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 8 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif49_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif49_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif49_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif49_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif49_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif49_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif49_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif49_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7A_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7A_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7A_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7A_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7A_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7A_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7A_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7A_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 8 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif2B_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif2B_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif2B_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif2B_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif2B_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif2B_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif2B_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif2B_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 8 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif76_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif76_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif76_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif76_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif76_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif76_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif76_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif76_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 8 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7B_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7B_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7B_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7B_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7B_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7B_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7B_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7B_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_cpll_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_cpll_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_cpll_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_cpll_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_cpll_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_cpll_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_cpll_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif72_cpll_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 8 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/reg14_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/reg14_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/reg14_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/reg14_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/reg14_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/reg14_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/reg14_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/reg14_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 8 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/st_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/st_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/st_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/st_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/st_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/st_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/st_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/st_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 8 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif36_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif36_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif36_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif36_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif36_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif36_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif36_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif36_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 8 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif64_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif64_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif64_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif64_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif64_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif64_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif64_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif64_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 8 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7E_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7E_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7E_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7E_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7E_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7E_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7E_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif7E_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 8 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif3A_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif3A_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif3A_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif3A_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif3A_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif3A_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif3A_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif3A_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 8 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif69_dbg[0]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif69_dbg[1]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif69_dbg[2]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif69_dbg[3]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif69_dbg[4]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif69_dbg[5]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif69_dbg[6]} {x4_bd_i/radar_ctrl_top_0/inst/u_init/pif69_dbg[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 4 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/flush3a_cnt_sig[0]} {x4_bd_i/radar_ctrl_top_0/inst/flush3a_cnt_sig[1]} {x4_bd_i/radar_ctrl_top_0/inst/flush3a_cnt_sig[2]} {x4_bd_i/radar_ctrl_top_0/inst/flush3a_cnt_sig[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 2 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/spi_sel_sig[0]} {x4_bd_i/radar_ctrl_top_0/inst/spi_sel_sig[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 8 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list {x4_bd_i/radar_ctrl_top_0/inst/top_fsm_st[0]} {x4_bd_i/radar_ctrl_top_0/inst/top_fsm_st[1]} {x4_bd_i/radar_ctrl_top_0/inst/top_fsm_st[2]} {x4_bd_i/radar_ctrl_top_0/inst/top_fsm_st[3]} {x4_bd_i/radar_ctrl_top_0/inst/top_fsm_st[4]} {x4_bd_i/radar_ctrl_top_0/inst/top_fsm_st[5]} {x4_bd_i/radar_ctrl_top_0/inst/top_fsm_st[6]} {x4_bd_i/radar_ctrl_top_0/inst/top_fsm_st[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list x4_bd_i/radar_ctrl_top_0/inst/burst_busy_sig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list x4_bd_i/radar_ctrl_top_0/inst/burst_done_sig]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list x4_bd_i/radar_ctrl_top_0/inst/burst_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list x4_bd_i/radar_ctrl_top_0/inst/u_init/cs_dbg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list x4_bd_i/radar_ctrl_top_0/inst/u_init/miso_dbg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list x4_bd_i/radar_ctrl_top_0/inst/u_init/mosi_dbg]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list x4_bd_i/radar_ctrl_top_0/inst/u_init/sck_dbg]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets u_ila_0_FCLK_CLK0]
