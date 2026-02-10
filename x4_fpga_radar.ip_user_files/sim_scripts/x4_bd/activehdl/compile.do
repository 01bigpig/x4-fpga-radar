transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib activehdl/xilinx_vip
vlib activehdl/xpm
vlib activehdl/axi_infrastructure_v1_1_0
vlib activehdl/axi_vip_v1_1_22
vlib activehdl/processing_system7_vip_v1_0_24
vlib activehdl/xil_defaultlib
vlib activehdl/axi_bram_ctrl_v4_1_13
vlib activehdl/blk_mem_gen_v8_4_12
vlib activehdl/proc_sys_reset_v5_0_17
vlib activehdl/smartconnect_v1_0
vlib activehdl/axi_register_slice_v2_1_36

vmap xilinx_vip activehdl/xilinx_vip
vmap xpm activehdl/xpm
vmap axi_infrastructure_v1_1_0 activehdl/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_22 activehdl/axi_vip_v1_1_22
vmap processing_system7_vip_v1_0_24 activehdl/processing_system7_vip_v1_0_24
vmap xil_defaultlib activehdl/xil_defaultlib
vmap axi_bram_ctrl_v4_1_13 activehdl/axi_bram_ctrl_v4_1_13
vmap blk_mem_gen_v8_4_12 activehdl/blk_mem_gen_v8_4_12
vmap proc_sys_reset_v5_0_17 activehdl/proc_sys_reset_v5_0_17
vmap smartconnect_v1_0 activehdl/smartconnect_v1_0
vmap axi_register_slice_v2_1_36 activehdl/axi_register_slice_v2_1_36

vlog -work xilinx_vip  -sv2k12 "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"C:/AMDDesignTools/2025.2/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/AMDDesignTools/2025.2/Vivado/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/AMDDesignTools/2025.2/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93  \
"C:/AMDDesignTools/2025.2/Vivado/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_22  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/b16a/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work processing_system7_vip_v1_0_24  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl/processing_system7_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_processing_system7_0_0/sim/x4_bd_processing_system7_0_0.v" \

vcom -work axi_bram_ctrl_v4_1_13 -93  \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/2f03/hdl/axi_bram_ctrl_v4_1_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../bd/x4_bd/ip/x4_bd_axi_bram_ctrl_0_0/sim/x4_bd_axi_bram_ctrl_0_0.vhd" \

vlog -work blk_mem_gen_v8_4_12  -v2k5 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/42f3/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_blk_mem_gen_0_0/sim/x4_bd_blk_mem_gen_0_0.v" \

vcom -work proc_sys_reset_v5_0_17 -93  \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9438/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93  \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_1/sim/bd_aabe_psr_aclk_0.vhd" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/sc_util_v1_0_vl_rfs.sv" \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/3d9a/hdl/sc_mmu_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_2/sim/bd_aabe_s00mmu_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/7785/hdl/sc_transaction_regulator_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_3/sim/bd_aabe_s00tr_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/3051/hdl/sc_si_converter_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_4/sim/bd_aabe_s00sic_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/852f/hdl/sc_axi2sc_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_5/sim/bd_aabe_s00a2s_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/sc_node_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_6/sim/bd_aabe_sarn_0.sv" \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_7/sim/bd_aabe_srn_0.sv" \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_8/sim/bd_aabe_sawn_0.sv" \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_9/sim/bd_aabe_swn_0.sv" \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_10/sim/bd_aabe_sbn_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/fca9/hdl/sc_sc2axi_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_11/sim/bd_aabe_m00s2a_0.sv" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/e44a/hdl/sc_exit_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/ip/ip_12/sim/bd_aabe_m00e_0.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/bd_0/sim/bd_aabe.v" \

vcom -work smartconnect_v1_0 -93  \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/cb42/hdl/sc_ultralite_v1_0_rfs.vhd" \

vlog -work smartconnect_v1_0  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/cb42/hdl/sc_ultralite_v1_0_rfs.sv" \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/0848/hdl/sc_switchboard_v1_0_vl_rfs.sv" \

vlog -work axi_register_slice_v2_1_36  -v2k5 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/bc4b/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_axi_smc_0/sim/x4_bd_axi_smc_0.sv" \

vcom -work xil_defaultlib -93  \
"../../../bd/x4_bd/ip/x4_bd_rst_ps7_0_100M_0/sim/x4_bd_rst_ps7_0_100M_0.vhd" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/ec67/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/9a25/hdl" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/f0b6/hdl/verilog" "+incdir+../../../../project_8.gen/sources_1/bd/x4_bd/ipshared/00fe/hdl/verilog" "+incdir+../../../../../../../AMDDesignTools/2025.2/Vivado/data/rsb/busdef" "+incdir+C:/AMDDesignTools/2025.2/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l axi_infrastructure_v1_1_0 -l axi_vip_v1_1_22 -l processing_system7_vip_v1_0_24 -l xil_defaultlib -l axi_bram_ctrl_v4_1_13 -l blk_mem_gen_v8_4_12 -l proc_sys_reset_v5_0_17 -l smartconnect_v1_0 -l axi_register_slice_v2_1_36 \
"../../../bd/x4_bd/ip/x4_bd_radar_ctrl_top_0_0/sim/x4_bd_radar_ctrl_top_0_0.v" \
"../../../bd/x4_bd/sim/x4_bd.v" \

vlog -work xil_defaultlib \
"glbl.v"

