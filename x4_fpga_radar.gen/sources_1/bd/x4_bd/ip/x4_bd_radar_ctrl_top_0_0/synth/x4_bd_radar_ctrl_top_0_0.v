// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2026 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:module_ref:radar_ctrl_top:1.0
// IP Revision: 1

(* X_CORE_INFO = "radar_ctrl_top,Vivado 2025.2" *)
(* CHECK_LICENSE_TYPE = "x4_bd_radar_ctrl_top_0_0,radar_ctrl_top,{}" *)
(* CORE_GENERATION_INFO = "x4_bd_radar_ctrl_top_0_0,radar_ctrl_top,{x_ipProduct=Vivado 2025.2,x_ipVendor=xilinx.com,x_ipLibrary=module_ref,x_ipName=radar_ctrl_top,x_ipVersion=1.0,x_ipCoreRevision=1,x_ipLanguage=VERILOG,x_ipSimLanguage=MIXED,CLK_DIV_BURST=5,BURST_BYTE_COUNT=9216,PIF_RESET_CNTR_ADDR=00101011,PIF_TRX_START_ADDR=00110110,PIF_DONE_ADDR=00111010,PIF_RAMSEL_ADDR=00100111,PIF_1D_ADDR=00011101,WR_WAIT_CYCLES=0x0000C350,POLL_TIMEOUT=0x004C4B40}" *)
(* IP_DEFINITION_SOURCE = "module_ref" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module x4_bd_radar_ctrl_top_0_0 (
  clk_100m,
  spi_sck,
  spi_mosi,
  spi_miso,
  spi_cs_n,
  bram_addrb,
  bram_clkb,
  bram_enb,
  bram_web,
  bram_dinb,
  bram_doutb,
  bram_rstb
);

input wire clk_100m;
output wire spi_sck;
output wire spi_mosi;
input wire spi_miso;
output wire spi_cs_n;
output wire [11 : 0] bram_addrb;
output wire bram_clkb;
output wire bram_enb;
output wire [3 : 0] bram_web;
output wire [31 : 0] bram_dinb;
input wire [31 : 0] bram_doutb;
output wire bram_rstb;

  radar_ctrl_top #(
    .CLK_DIV_BURST(5),
    .BURST_BYTE_COUNT(9216),
    .PIF_RESET_CNTR_ADDR(8'B00101011),
    .PIF_TRX_START_ADDR(8'B00110110),
    .PIF_DONE_ADDR(8'B00111010),
    .PIF_RAMSEL_ADDR(8'B00100111),
    .PIF_1D_ADDR(8'B00011101),
    .WR_WAIT_CYCLES(32'H0000C350),
    .POLL_TIMEOUT(32'H004C4B40)
  ) inst (
    .clk_100m(clk_100m),
    .spi_sck(spi_sck),
    .spi_mosi(spi_mosi),
    .spi_miso(spi_miso),
    .spi_cs_n(spi_cs_n),
    .bram_addrb(bram_addrb),
    .bram_clkb(bram_clkb),
    .bram_enb(bram_enb),
    .bram_web(bram_web),
    .bram_dinb(bram_dinb),
    .bram_doutb(bram_doutb),
    .bram_rstb(bram_rstb)
  );
endmodule
