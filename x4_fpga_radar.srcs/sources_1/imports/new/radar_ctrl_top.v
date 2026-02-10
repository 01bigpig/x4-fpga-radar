// ============================================================
// top_x4_pif_init_membridge.v  (Verilog-2001)
//
// 用 mem-bridge 做一整套上电：
//   1) 写 PIF：
//        0x8076 = 0x13
//        0x8078 = 0x10
//        0x807A = 0x13
//        0x807B = 0x08
//   2) 用 mem_readback 读回：0x8076/78/7A/7B/7E
//      - 读到 0x807E 的低 4 位 == 0xF 才继续
//   3) XOSC：
//      - 写 PIF 0x804A = 0x02
//      - mem_readback 轮询 PIF 0x8072 bit6 == 1
//   4) SYSCLK：
//      - 写 PIF 0x804A = 0x22
//      - mem_readback 读 PIF 0x804A，确认 == 0x22
//   5) Common PLL：
//      - 写 PIF 0x806A = 0x60
//      - mem_readback 轮询 PIF 0x8072 bit7 == 1
//   6) 其它寄存器：
//      - 写 PIF 0x8066 = 0x00, 0x8061 = 0x00, 0x8073 = 0x10, 0x8049 = 0x08
//      - 读回 PIF 0x8069 / 0x8064 / 0x8073 / 0x8049
//
// 所有 PIF 读写都严格统一模板：
//   写：18=0x80, 19=addr, 13=data, 17=0x01, 等待, 17=0x00
//   读：18=0x80, 19=addr, 17=0x02,
//       poll 14[2]==1,
//       R 15 -> 保存一次有效值,
//       立刻 17=0x00,
//       再用 14/15 把 FIFO 剩余数据读空，再换地址
// ============================================================

module top_x4_pif_init_membridge(
    input  wire clk_100m,
    output wire spi_sck,
    output wire spi_mosi,
    input  wire spi_miso,
    output wire spi_cs_n
);

    // ---------------- POR reset ----------------
    localparam integer POR_CYCLES = 32'd5_000_000; // ~50ms @100MHz
    reg [31:0] por_cnt = 32'd0;
    reg        rst_n_r  = 1'b0;
    wire       rst_n    = rst_n_r;

    always @(posedge clk_100m) begin
        if (!rst_n_r) begin
            if (por_cnt >= POR_CYCLES) rst_n_r <= 1'b1;
            else por_cnt <= por_cnt + 1'b1;
        end
    end

    // ---------------- SPI reg service ----------------
    reg        cmd_valid;
    reg        cmd_write;
    reg [7:0]  cmd_addr;
    reg [7:0]  cmd_wdata;
    wire       cmd_ready;

    wire       rsp_valid;
    wire [7:0] rsp_rdata;

    wire [15:0] last_tx16_w;
    wire [15:0] last_rx16_w;

    x4_spi_reg_service #(.CLK_DIV(5)) u_srv (
        .clk       (clk_100m),
        .rst_n     (rst_n),

        .cmd_valid (cmd_valid),
        .cmd_write (cmd_write),
        .cmd_addr  (cmd_addr),
        .cmd_wdata (cmd_wdata),
        .cmd_ready (cmd_ready),

        .rsp_valid (rsp_valid),
        .rsp_rdata (rsp_rdata),

        .spi_sck   (spi_sck),
        .spi_mosi  (spi_mosi),
        .spi_miso  (spi_miso),
        .spi_cs_n  (spi_cs_n),

        .last_tx16 (last_tx16_w),
        .last_rx16 (last_rx16_w)
    );

    // ---------------- helper task (提交一条命令) ----------------
    task issue_cmd;
        input        w;   // 1=write, 0=read
        input [7:0]  a;   // addr
        input [7:0]  d;   // data
        begin
            cmd_write <= w;
            cmd_addr  <= a;
            cmd_wdata <= d;
            cmd_valid <= 1'b1;
        end
    endtask

    // 写之后的简单等待
    localparam integer WR_WAIT_CYCLES = 32'd50_000;    // ~0.5ms @100MHz
    reg [31:0] wr_wait_cnt;

    // poll 0x14 bit2 超时
    localparam integer POLL_TIMEOUT   = 32'd5_000_000; // ~50ms
    reg [31:0] poll_to;

    // ---------------- index & LUT（Stage1） ----------------
    reg [1:0] wr_idx;  // 0..3 -> 76/78/7A/7B
    reg [2:0] rd_idx;  // 0..4 -> 76/78/7A/7B/7E

    function [7:0] wr_low_addr;
        input [1:0] idx;
        begin
            case (idx)
                2'd0: wr_low_addr = 8'h76; // 0x8076
                2'd1: wr_low_addr = 8'h78; // 0x8078
                2'd2: wr_low_addr = 8'h7A; // 0x807A
                2'd3: wr_low_addr = 8'h7B; // 0x807B
                default: wr_low_addr = 8'h00;
            endcase
        end
    endfunction

    function [7:0] wr_data;
        input [1:0] idx;
        begin
            case (idx)
                2'd0: wr_data = 8'h13; // 0x8076 = 0x13
                2'd1: wr_data = 8'h10; // 0x8078 = 0x10
                2'd2: wr_data = 8'h13; // 0x807A = 0x13
                2'd3: wr_data = 8'h08; // 0x807B = 0x08
                default: wr_data = 8'h00;
            endcase
        end
    endfunction

    function [7:0] rd_low_addr;
        input [2:0] idx;
        begin
            case (idx)
                3'd0: rd_low_addr = 8'h76;
                3'd1: rd_low_addr = 8'h78;
                3'd2: rd_low_addr = 8'h7A;
                3'd3: rd_low_addr = 8'h7B;
                3'd4: rd_low_addr = 8'h7E; // LDO status
                default: rd_low_addr = 8'h00;
            endcase
        end
    endfunction

    // ---------------- Stage2 的 LUT（66/61/73/49 + 69/64/73/49） ----------------
    reg [1:0] wr2_idx;  // 0..3 对应下面 LUT
    reg [1:0] rd2_idx;  // 0..3 对应下面 LUT

    function [7:0] wr2_low_addr;
        input [1:0] idx;
        begin
            case (idx)
                2'd0: wr2_low_addr = 8'h66; // 0x8066
                2'd1: wr2_low_addr = 8'h61; // 0x8061
                2'd2: wr2_low_addr = 8'h73; // 0x8073
                2'd3: wr2_low_addr = 8'h49; // 0x8049
                default: wr2_low_addr = 8'h00;
            endcase
        end
    endfunction

    function [7:0] wr2_data;
        input [1:0] idx;
        begin
            case (idx)
                2'd0: wr2_data = 8'h00; // 0x8066
                2'd1: wr2_data = 8'h00; // 0x8061
                2'd2: wr2_data = 8'h10; // 0x8073
                2'd3: wr2_data = 8'h08; // 0x8049
                default: wr2_data = 8'h00;
            endcase
        end
    endfunction

    function [7:0] rd2_low_addr;
        input [1:0] idx;
        begin
            case (idx)
                2'd0: rd2_low_addr = 8'h69; // 0x8069
                2'd1: rd2_low_addr = 8'h64; // 0x8064
                2'd2: rd2_low_addr = 8'h73; // 0x8073
                2'd3: rd2_low_addr = 8'h49; // 0x8049
                default: rd2_low_addr = 8'h00;
            endcase
        end
    endfunction

    // ---------------- FSM state encoding ----------------
    reg [7:0] st;

    localparam [7:0]
        // Stage1: 写 0x8076/78/7A/7B
        ST_WR_INIT        = 8'd0,
        ST_WR_18          = 8'd1,
        ST_WR_18_W        = 8'd2,
        ST_WR_19          = 8'd3,
        ST_WR_19_W        = 8'd4,
        ST_WR_13          = 8'd5,
        ST_WR_13_W        = 8'd6,
        ST_WR_17_01       = 8'd7,
        ST_WR_17_01_W     = 8'd8,
        ST_WR_WAIT        = 8'd9,
        ST_WR_17_CLR      = 8'd10,
        ST_WR_17_CLR_W    = 8'd11,
        ST_WR_NEXT        = 8'd12,

        // Stage1: 读回 0x8076/78/7A/7B/7E
        ST_RD_INIT        = 8'd20,
        ST_RD_18          = 8'd21,
        ST_RD_18_W        = 8'd22,
        ST_RD_19          = 8'd23,
        ST_RD_19_W        = 8'd24,
        ST_RD_17_02       = 8'd25,
        ST_RD_17_02_W     = 8'd26,
        ST_RD_P14_CMD     = 8'd27,
        ST_RD_P14_WAIT    = 8'd28,
        ST_RD_15_CMD      = 8'd29,
        ST_RD_15_WAIT     = 8'd30,
        ST_RD_17_CLR      = 8'd31,
        ST_RD_17_CLR_W    = 8'd32,
        ST_FLUSH_P14_CMD  = 8'd33,
        ST_FLUSH_P14_WAIT = 8'd34,
        ST_FLUSH_15_CMD   = 8'd35,
        ST_FLUSH_15_WAIT  = 8'd36,
        ST_RD_NEXT        = 8'd37,

        // 4A = 0x02 （XOSC 之前）
        ST_4A_WR_18       = 8'd40,
        ST_4A_WR_18_W     = 8'd41,
        ST_4A_WR_19       = 8'd42,
        ST_4A_WR_19_W     = 8'd43,
        ST_4A_WR_13_02    = 8'd44,
        ST_4A_WR_13_02_W  = 8'd45,
        ST_4A_WR_17_01    = 8'd46,
        ST_4A_WR_17_01_W  = 8'd47,
        ST_4A_WR_WAIT     = 8'd48,
        ST_4A_WR_17_CLR   = 8'd49,
        ST_4A_WR_17_CLR_W = 8'd50,

        // 72 (XOSC) mem_readback, poll bit6
        ST_72A_RD_18          = 8'd60,
        ST_72A_RD_18_W        = 8'd61,
        ST_72A_RD_19          = 8'd62,
        ST_72A_RD_19_W        = 8'd63,
        ST_72A_RD_17_02       = 8'd64,
        ST_72A_RD_17_02_W     = 8'd65,
        ST_72A_RD_P14_CMD     = 8'd66,
        ST_72A_RD_P14_WAIT    = 8'd67,
        ST_72A_RD_15_CMD      = 8'd68,
        ST_72A_RD_15_WAIT     = 8'd69,
        ST_72A_RD_17_CLR      = 8'd70,
        ST_72A_RD_17_CLR_W    = 8'd71,
        ST_72A_FLUSH_P14_CMD  = 8'd72,
        ST_72A_FLUSH_P14_WAIT = 8'd73,
        ST_72A_FLUSH_15_CMD   = 8'd74,
        ST_72A_FLUSH_15_WAIT  = 8'd75,
        ST_72A_NEXT           = 8'd76,

        // 4A = 0x22 + 读回确认
        ST_4A_WR2_18          = 8'd80,
        ST_4A_WR2_18_W        = 8'd81,
        ST_4A_WR2_19          = 8'd82,
        ST_4A_WR2_19_W        = 8'd83,
        ST_4A_WR2_13_22       = 8'd84,
        ST_4A_WR2_13_22_W     = 8'd85,
        ST_4A_WR2_17_01       = 8'd86,
        ST_4A_WR2_17_01_W     = 8'd87,
        ST_4A_WR2_WAIT        = 8'd88,
        ST_4A_WR2_17_CLR      = 8'd89,
        ST_4A_WR2_17_CLR_W    = 8'd90,

        ST_4A_RD2_18          = 8'd92,
        ST_4A_RD2_18_W        = 8'd93,
        ST_4A_RD2_19          = 8'd94,
        ST_4A_RD2_19_W        = 8'd95,
        ST_4A_RD2_17_02       = 8'd96,
        ST_4A_RD2_17_02_W     = 8'd97,
        ST_4A_RD2_P14_CMD     = 8'd98,
        ST_4A_RD2_P14_WAIT    = 8'd99,
        ST_4A_RD2_15_CMD      = 8'd100,
        ST_4A_RD2_15_WAIT     = 8'd101,
        ST_4A_RD2_17_CLR      = 8'd102,
        ST_4A_RD2_17_CLR_W    = 8'd103,
        ST_4A_RD2_FLUSH_P14_CMD  = 8'd104,
        ST_4A_RD2_FLUSH_P14_WAIT = 8'd105,
        ST_4A_RD2_FLUSH_15_CMD   = 8'd106,
        ST_4A_RD2_FLUSH_15_WAIT  = 8'd107,
        ST_4A_RD2_NEXT           = 8'd108,

        // 6A = 0x60
        ST_6A_WR_18        = 8'd110,
        ST_6A_WR_18_W      = 8'd111,
        ST_6A_WR_19        = 8'd112,
        ST_6A_WR_19_W      = 8'd113,
        ST_6A_WR_13_60     = 8'd114,
        ST_6A_WR_13_60_W   = 8'd115,
        ST_6A_WR_17_01     = 8'd116,
        ST_6A_WR_17_01_W   = 8'd117,
        ST_6A_WR_WAIT      = 8'd118,
        ST_6A_WR_17_CLR    = 8'd119,
        ST_6A_WR_17_CLR_W  = 8'd120,

        // 72 (Common PLL) mem_readback, poll bit7
        ST_72B_RD_18          = 8'd130,
        ST_72B_RD_18_W        = 8'd131,
        ST_72B_RD_19          = 8'd132,
        ST_72B_RD_19_W        = 8'd133,
        ST_72B_RD_17_02       = 8'd134,
        ST_72B_RD_17_02_W     = 8'd135,
        ST_72B_RD_P14_CMD     = 8'd136,
        ST_72B_RD_P14_WAIT    = 8'd137,
        ST_72B_RD_15_CMD      = 8'd138,
        ST_72B_RD_15_WAIT     = 8'd139,
        ST_72B_RD_17_CLR      = 8'd140,
        ST_72B_RD_17_CLR_W    = 8'd141,
        ST_72B_FLUSH_P14_CMD  = 8'd142,
        ST_72B_FLUSH_P14_WAIT = 8'd143,
        ST_72B_FLUSH_15_CMD   = 8'd144,
        ST_72B_FLUSH_15_WAIT  = 8'd145,
        ST_72B_NEXT           = 8'd146,

        // Stage2: 66/61/73/49 写 & 69/64/73/49 读
        ST2_WR_INIT        = 8'd150,
        ST2_WR_18          = 8'd151,
        ST2_WR_18_W        = 8'd152,
        ST2_WR_19          = 8'd153,
        ST2_WR_19_W        = 8'd154,
        ST2_WR_13          = 8'd155,
        ST2_WR_13_W        = 8'd156,
        ST2_WR_17_01       = 8'd157,
        ST2_WR_17_01_W     = 8'd158,
        ST2_WR_WAIT        = 8'd159,
        ST2_WR_17_CLR      = 8'd160,
        ST2_WR_17_CLR_W    = 8'd161,
        ST2_WR_NEXT        = 8'd162,

        ST2_RD_INIT        = 8'd170,
        ST2_RD_18          = 8'd171,
        ST2_RD_18_W        = 8'd172,
        ST2_RD_19          = 8'd173,
        ST2_RD_19_W        = 8'd174,
        ST2_RD_17_02       = 8'd175,
        ST2_RD_17_02_W     = 8'd176,
        ST2_RD_P14_CMD     = 8'd177,
        ST2_RD_P14_WAIT    = 8'd178,
        ST2_RD_15_CMD      = 8'd179,
        ST2_RD_15_WAIT     = 8'd180,
        ST2_RD_17_CLR      = 8'd181,
        ST2_RD_17_CLR_W    = 8'd182,
        ST2_FLUSH_P14_CMD  = 8'd183,
        ST2_FLUSH_P14_WAIT = 8'd184,
        ST2_FLUSH_15_CMD   = 8'd185,
        ST2_FLUSH_15_WAIT  = 8'd186,
        ST2_RD_NEXT        = 8'd187,

        ST_DONE            = 8'd240,
        ST_ERR             = 8'd241;

    // ---------------- 调试寄存器 ----------------
    reg [7:0] reg14;
    reg [7:0] pif76_data, pif78_data, pif7A_data, pif7B_data, pif7E_data;
    reg [7:0] pif4A_data;        // 读回 4A
    reg [7:0] pif72_xosc_data;   // 72 for XOSC
    reg [7:0] pif72_cpll_data;   // 72 for CPLL

    reg [7:0] pif69_data, pif64_data, pif73_data, pif49_data;

    // ---------------- main FSM ----------------
    always @(posedge clk_100m or negedge rst_n) begin
        if (!rst_n) begin
            cmd_valid   <= 1'b0;
            cmd_write   <= 1'b0;
            cmd_addr    <= 8'h00;
            cmd_wdata   <= 8'h00;

            st          <= ST_WR_INIT;
            wr_wait_cnt <= 32'd0;
            poll_to     <= 32'd0;

            wr_idx      <= 2'd0;
            rd_idx      <= 3'd0;
            wr2_idx     <= 2'd0;
            rd2_idx     <= 2'd0;

            reg14       <= 8'h00;
            pif76_data  <= 8'h00;
            pif78_data  <= 8'h00;
            pif7A_data  <= 8'h00;
            pif7B_data  <= 8'h00;
            pif7E_data  <= 8'h00;

            pif4A_data      <= 8'h00;
            pif72_xosc_data <= 8'h00;
            pif72_cpll_data <= 8'h00;

            pif69_data  <= 8'h00;
            pif64_data  <= 8'h00;
            pif73_data  <= 8'h00;
            pif49_data  <= 8'h00;

        end else begin
            cmd_valid <= 1'b0;

            case (st)
                // ====================================================
                // Stage1: 写 0x8076/78/7A/7B
                // ====================================================
                ST_WR_INIT: begin
                    wr_idx      <= 2'd0;
                    wr_wait_cnt <= 32'd0;
                    st          <= ST_WR_18;
                end

                ST_WR_18: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h18, 8'h80);
                    st <= ST_WR_18_W;
                end
                ST_WR_18_W: if (rsp_valid) begin
                    st <= ST_WR_19;
                end

                ST_WR_19: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h19, wr_low_addr(wr_idx));
                    st <= ST_WR_19_W;
                end
                ST_WR_19_W: if (rsp_valid) begin
                    st <= ST_WR_13;
                end

                ST_WR_13: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h13, wr_data(wr_idx));
                    st <= ST_WR_13_W;
                end
                ST_WR_13_W: if (rsp_valid) begin
                    st <= ST_WR_17_01;
                end

                ST_WR_17_01: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h01);
                    st <= ST_WR_17_01_W;
                end
                ST_WR_17_01_W: if (rsp_valid) begin
                    wr_wait_cnt <= 32'd0;
                    st          <= ST_WR_WAIT;
                end

                ST_WR_WAIT: begin
                    if (wr_wait_cnt >= WR_WAIT_CYCLES) begin
                        st <= ST_WR_17_CLR;
                    end else begin
                        wr_wait_cnt <= wr_wait_cnt + 1'b1;
                    end
                end

                ST_WR_17_CLR: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h00);
                    st <= ST_WR_17_CLR_W;
                end
                ST_WR_17_CLR_W: if (rsp_valid) begin
                    st <= ST_WR_NEXT;
                end

                ST_WR_NEXT: begin
                    if (wr_idx == 2'd3) begin
                        st <= ST_RD_INIT;
                    end else begin
                        wr_idx <= wr_idx + 1'b1;
                        st     <= ST_WR_18;
                    end
                end

                // ====================================================
                // Stage1: mem_readback 读 0x8076/78/7A/7B/7E
                // ====================================================
                ST_RD_INIT: begin
                    rd_idx  <= 3'd0;
                    poll_to <= 32'd0;
                    st      <= ST_RD_18;
                end

                ST_RD_18: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h18, 8'h80);
                    st <= ST_RD_18_W;
                end
                ST_RD_18_W: if (rsp_valid) begin
                    st <= ST_RD_19;
                end

                ST_RD_19: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h19, rd_low_addr(rd_idx));
                    st <= ST_RD_19_W;
                end
                ST_RD_19_W: if (rsp_valid) begin
                    st <= ST_RD_17_02;
                end

                ST_RD_17_02: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h02);
                    st <= ST_RD_17_02_W;
                end
                ST_RD_17_02_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_RD_P14_CMD;
                end

                ST_RD_P14_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h14, 8'h00);
                    st <= ST_RD_P14_WAIT;
                end
                ST_RD_P14_WAIT: if (rsp_valid) begin
                    reg14 <= rsp_rdata;
                    if (rsp_rdata[2]) begin
                        st <= ST_RD_15_CMD;
                    end else if (poll_to >= POLL_TIMEOUT) begin
                        st <= ST_ERR;
                    end else begin
                        poll_to <= poll_to + 1'b1;
                        st      <= ST_RD_P14_CMD;
                    end
                end

                ST_RD_15_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h15, 8'h00);
                    st <= ST_RD_15_WAIT;
                end
                ST_RD_15_WAIT: if (rsp_valid) begin
                    case (rd_idx)
                        3'd0: pif76_data <= rsp_rdata;
                        3'd1: pif78_data <= rsp_rdata;
                        3'd2: pif7A_data <= rsp_rdata;
                        3'd3: pif7B_data <= rsp_rdata;
                        3'd4: pif7E_data <= rsp_rdata;
                        default: ;
                    endcase
                    st <= ST_RD_17_CLR;
                end

                ST_RD_17_CLR: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h00);
                    st <= ST_RD_17_CLR_W;
                end
                ST_RD_17_CLR_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_FLUSH_P14_CMD;
                end

                ST_FLUSH_P14_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h14, 8'h00);
                    st <= ST_FLUSH_P14_WAIT;
                end
                ST_FLUSH_P14_WAIT: if (rsp_valid) begin
                    reg14 <= rsp_rdata;
                    if (rsp_rdata[2]) begin
                        st <= ST_FLUSH_15_CMD;
                    end else if (poll_to >= POLL_TIMEOUT) begin
                        st <= ST_ERR;
                    end else begin
                        st <= ST_RD_NEXT;
                    end
                end

                ST_FLUSH_15_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h15, 8'h00);
                    st <= ST_FLUSH_15_WAIT;
                end
                ST_FLUSH_15_WAIT: if (rsp_valid) begin
                    poll_to <= poll_to + 1'b1;
                    st      <= ST_FLUSH_P14_CMD;
                end

                ST_RD_NEXT: begin
                    if (rd_idx == 3'd4) begin
                        // 刚读完 0x807E，看低 4 位是不是 0xF
                        if (pif7E_data[3:0] == 4'hF)
                            st <= ST_4A_WR_18;
                        else
                            st <= ST_ERR;
                    end else begin
                        rd_idx  <= rd_idx + 1'b1;
                        poll_to <= 32'd0;
                        st      <= ST_RD_18;
                    end
                end

                // ====================================================
                // 4A = 0x02 (mem-bridge 写 PIF 0x804A)
                // ====================================================
                ST_4A_WR_18: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h18, 8'h80);
                    st <= ST_4A_WR_18_W;
                end
                ST_4A_WR_18_W: if (rsp_valid) begin
                    st <= ST_4A_WR_19;
                end

                ST_4A_WR_19: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h19, 8'h4A);
                    st <= ST_4A_WR_19_W;
                end
                ST_4A_WR_19_W: if (rsp_valid) begin
                    st <= ST_4A_WR_13_02;
                end

                ST_4A_WR_13_02: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h13, 8'h02);
                    st <= ST_4A_WR_13_02_W;
                end
                ST_4A_WR_13_02_W: if (rsp_valid) begin
                    st <= ST_4A_WR_17_01;
                end

                ST_4A_WR_17_01: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h01);
                    st <= ST_4A_WR_17_01_W;
                end
                ST_4A_WR_17_01_W: if (rsp_valid) begin
                    wr_wait_cnt <= 32'd0;
                    st          <= ST_4A_WR_WAIT;
                end

                ST_4A_WR_WAIT: begin
                    if (wr_wait_cnt >= WR_WAIT_CYCLES) begin
                        st <= ST_4A_WR_17_CLR;
                    end else begin
                        wr_wait_cnt <= wr_wait_cnt + 1'b1;
                    end
                end

                ST_4A_WR_17_CLR: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h00);
                    st <= ST_4A_WR_17_CLR_W;
                end
                ST_4A_WR_17_CLR_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_72A_RD_18;
                end

                // ====================================================
                // 72 (XOSC) mem_readback，poll bit6
                // ====================================================
                ST_72A_RD_18: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h18, 8'h80);
                    st <= ST_72A_RD_18_W;
                end
                ST_72A_RD_18_W: if (rsp_valid) begin
                    st <= ST_72A_RD_19;
                end

                ST_72A_RD_19: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h19, 8'h72);
                    st <= ST_72A_RD_19_W;
                end
                ST_72A_RD_19_W: if (rsp_valid) begin
                    st <= ST_72A_RD_17_02;
                end

                ST_72A_RD_17_02: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h02);
                    st <= ST_72A_RD_17_02_W;
                end
                ST_72A_RD_17_02_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_72A_RD_P14_CMD;
                end

                ST_72A_RD_P14_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h14, 8'h00);
                    st <= ST_72A_RD_P14_WAIT;
                end
                ST_72A_RD_P14_WAIT: if (rsp_valid) begin
                    reg14 <= rsp_rdata;
                    if (rsp_rdata[2]) begin
                        st <= ST_72A_RD_15_CMD;
                    end else if (poll_to >= POLL_TIMEOUT) begin
                        st <= ST_ERR;
                    end else begin
                        poll_to <= poll_to + 1'b1;
                        st      <= ST_72A_RD_P14_CMD;
                    end
                end

                ST_72A_RD_15_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h15, 8'h00);
                    st <= ST_72A_RD_15_WAIT;
                end
                ST_72A_RD_15_WAIT: if (rsp_valid) begin
                    pif72_xosc_data <= rsp_rdata;
                    st <= ST_72A_RD_17_CLR;
                end

                ST_72A_RD_17_CLR: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h00);
                    st <= ST_72A_RD_17_CLR_W;
                end
                ST_72A_RD_17_CLR_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_72A_FLUSH_P14_CMD;
                end

                ST_72A_FLUSH_P14_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h14, 8'h00);
                    st <= ST_72A_FLUSH_P14_WAIT;
                end
                ST_72A_FLUSH_P14_WAIT: if (rsp_valid) begin
                    reg14 <= rsp_rdata;
                    if (rsp_rdata[2]) begin
                        st <= ST_72A_FLUSH_15_CMD;
                    end else if (poll_to >= POLL_TIMEOUT) begin
                        st <= ST_ERR;
                    end else begin
                        st <= ST_72A_NEXT;
                    end
                end

                ST_72A_FLUSH_15_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h15, 8'h00);
                    st <= ST_72A_FLUSH_15_WAIT;
                end
                ST_72A_FLUSH_15_WAIT: if (rsp_valid) begin
                    poll_to <= poll_to + 1'b1;
                    st      <= ST_72A_FLUSH_P14_CMD;
                end

                ST_72A_NEXT: begin
                    if (pif72_xosc_data[6]) begin
                        st <= ST_4A_WR2_18;
                    end else begin
                        poll_to <= 32'd0;
                        st      <= ST_72A_RD_18;  // 再来一轮
                    end
                end

                // ====================================================
                // 4A = 0x22 + mem_readback 确认
                // ====================================================
                ST_4A_WR2_18: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h18, 8'h80);
                    st <= ST_4A_WR2_18_W;
                end
                ST_4A_WR2_18_W: if (rsp_valid) begin
                    st <= ST_4A_WR2_19;
                end

                ST_4A_WR2_19: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h19, 8'h4A);
                    st <= ST_4A_WR2_19_W;
                end
                ST_4A_WR2_19_W: if (rsp_valid) begin
                    st <= ST_4A_WR2_13_22;
                end

                ST_4A_WR2_13_22: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h13, 8'h22);
                    st <= ST_4A_WR2_13_22_W;
                end
                ST_4A_WR2_13_22_W: if (rsp_valid) begin
                    st <= ST_4A_WR2_17_01;
                end

                ST_4A_WR2_17_01: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h01);
                    st <= ST_4A_WR2_17_01_W;
                end
                ST_4A_WR2_17_01_W: if (rsp_valid) begin
                    wr_wait_cnt <= 32'd0;
                    st          <= ST_4A_WR2_WAIT;
                end

                ST_4A_WR2_WAIT: begin
                    if (wr_wait_cnt >= WR_WAIT_CYCLES) begin
                        st <= ST_4A_WR2_17_CLR;
                    end else begin
                        wr_wait_cnt <= wr_wait_cnt + 1'b1;
                    end
                end

                ST_4A_WR2_17_CLR: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h00);
                    st <= ST_4A_WR2_17_CLR_W;
                end
                ST_4A_WR2_17_CLR_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_4A_RD2_18;
                end

                // ---- mem_readback 读 PIF 0x804A，确认 == 0x22 ----
                ST_4A_RD2_18: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h18, 8'h80);
                    st <= ST_4A_RD2_18_W;
                end
                ST_4A_RD2_18_W: if (rsp_valid) begin
                    st <= ST_4A_RD2_19;
                end

                ST_4A_RD2_19: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h19, 8'h4A);
                    st <= ST_4A_RD2_19_W;
                end
                ST_4A_RD2_19_W: if (rsp_valid) begin
                    st <= ST_4A_RD2_17_02;
                end

                ST_4A_RD2_17_02: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h02);
                    st <= ST_4A_RD2_17_02_W;
                end
                ST_4A_RD2_17_02_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_4A_RD2_P14_CMD;
                end

                ST_4A_RD2_P14_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h14, 8'h00);
                    st <= ST_4A_RD2_P14_WAIT;
                end
                ST_4A_RD2_P14_WAIT: if (rsp_valid) begin
                    reg14 <= rsp_rdata;
                    if (rsp_rdata[2]) begin
                        st <= ST_4A_RD2_15_CMD;
                    end else if (poll_to >= POLL_TIMEOUT) begin
                        st <= ST_ERR;
                    end else begin
                        poll_to <= poll_to + 1'b1;
                        st      <= ST_4A_RD2_P14_CMD;
                    end
                end

                ST_4A_RD2_15_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h15, 8'h00);
                    st <= ST_4A_RD2_15_WAIT;
                end
                ST_4A_RD2_15_WAIT: if (rsp_valid) begin
                    pif4A_data <= rsp_rdata;
                    st         <= ST_4A_RD2_17_CLR;
                end

                ST_4A_RD2_17_CLR: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h00);
                    st <= ST_4A_RD2_17_CLR_W;
                end
                ST_4A_RD2_17_CLR_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_4A_RD2_FLUSH_P14_CMD;
                end

                ST_4A_RD2_FLUSH_P14_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h14, 8'h00);
                    st <= ST_4A_RD2_FLUSH_P14_WAIT;
                end
                ST_4A_RD2_FLUSH_P14_WAIT: if (rsp_valid) begin
                    reg14 <= rsp_rdata;
                    if (rsp_rdata[2]) begin
                        st <= ST_4A_RD2_FLUSH_15_CMD;
                    end else if (poll_to >= POLL_TIMEOUT) begin
                        st <= ST_ERR;
                    end else begin
                        st <= ST_4A_RD2_NEXT;
                    end
                end

                ST_4A_RD2_FLUSH_15_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h15, 8'h00);
                    st <= ST_4A_RD2_FLUSH_15_WAIT;
                end
                ST_4A_RD2_FLUSH_15_WAIT: if (rsp_valid) begin
                    poll_to <= poll_to + 1'b1;
                    st      <= ST_4A_RD2_FLUSH_P14_CMD;
                end

                ST_4A_RD2_NEXT: begin
                    if (pif4A_data == 8'h22) begin
                        st <= ST_6A_WR_18;
                    end else begin
                        st <= ST_ERR;
                    end
                end

                // ====================================================
                // 6A = 0x60 (Common PLL 配置)
                // ====================================================
                ST_6A_WR_18: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h18, 8'h80);
                    st <= ST_6A_WR_18_W;
                end
                ST_6A_WR_18_W: if (rsp_valid) begin
                    st <= ST_6A_WR_19;
                end

                ST_6A_WR_19: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h19, 8'h6A);
                    st <= ST_6A_WR_19_W;
                end
                ST_6A_WR_19_W: if (rsp_valid) begin
                    st <= ST_6A_WR_13_60;
                end

                ST_6A_WR_13_60: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h13, 8'h60);
                    st <= ST_6A_WR_13_60_W;
                end
                ST_6A_WR_13_60_W: if (rsp_valid) begin
                    st <= ST_6A_WR_17_01;
                end

                ST_6A_WR_17_01: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h01);
                    st <= ST_6A_WR_17_01_W;
                end
                ST_6A_WR_17_01_W: if (rsp_valid) begin
                    wr_wait_cnt <= 32'd0;
                    st          <= ST_6A_WR_WAIT;
                end

                ST_6A_WR_WAIT: begin
                    if (wr_wait_cnt >= WR_WAIT_CYCLES) begin
                        st <= ST_6A_WR_17_CLR;
                    end else begin
                        wr_wait_cnt <= wr_wait_cnt + 1'b1;
                    end
                end

                ST_6A_WR_17_CLR: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h00);
                    st <= ST_6A_WR_17_CLR_W;
                end
                ST_6A_WR_17_CLR_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_72B_RD_18;
                end

                // ====================================================
                // 72 (CPLL) mem_readback，poll bit7
                // ====================================================
                ST_72B_RD_18: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h18, 8'h80);
                    st <= ST_72B_RD_18_W;
                end
                ST_72B_RD_18_W: if (rsp_valid) begin
                    st <= ST_72B_RD_19;
                end

                ST_72B_RD_19: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h19, 8'h72);
                    st <= ST_72B_RD_19_W;
                end
                ST_72B_RD_19_W: if (rsp_valid) begin
                    st <= ST_72B_RD_17_02;
                end

                ST_72B_RD_17_02: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h02);
                    st <= ST_72B_RD_17_02_W;
                end
                ST_72B_RD_17_02_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_72B_RD_P14_CMD;
                end

                ST_72B_RD_P14_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h14, 8'h00);
                    st <= ST_72B_RD_P14_WAIT;
                end
                ST_72B_RD_P14_WAIT: if (rsp_valid) begin
                    reg14 <= rsp_rdata;
                    if (rsp_rdata[2]) begin
                        st <= ST_72B_RD_15_CMD;
                    end else if (poll_to >= POLL_TIMEOUT) begin
                        st <= ST_ERR;
                    end else begin
                        poll_to <= poll_to + 1'b1;
                        st      <= ST_72B_RD_P14_CMD;
                    end
                end

                ST_72B_RD_15_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h15, 8'h00);
                    st <= ST_72B_RD_15_WAIT;
                end
                ST_72B_RD_15_WAIT: if (rsp_valid) begin
                    pif72_cpll_data <= rsp_rdata;
                    st              <= ST_72B_RD_17_CLR;
                end

                ST_72B_RD_17_CLR: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h00);
                    st <= ST_72B_RD_17_CLR_W;
                end
                ST_72B_RD_17_CLR_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST_72B_FLUSH_P14_CMD;
                end

                ST_72B_FLUSH_P14_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h14, 8'h00);
                    st <= ST_72B_FLUSH_P14_WAIT;
                end
                ST_72B_FLUSH_P14_WAIT: if (rsp_valid) begin
                    reg14 <= rsp_rdata;
                    if (rsp_rdata[2]) begin
                        st <= ST_72B_FLUSH_15_CMD;
                    end else if (poll_to >= POLL_TIMEOUT) begin
                        st <= ST_ERR;
                    end else begin
                        st <= ST_72B_NEXT;
                    end
                end

                ST_72B_FLUSH_15_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h15, 8'h00);
                    st <= ST_72B_FLUSH_15_WAIT;
                end
                ST_72B_FLUSH_15_WAIT: if (rsp_valid) begin
                    poll_to <= poll_to + 1'b1;
                    st      <= ST_72B_FLUSH_P14_CMD;
                end

                ST_72B_NEXT: begin
                    if (pif72_cpll_data[7]) begin
                        wr2_idx     <= 2'd0;
                        wr_wait_cnt <= 32'd0;
                        st          <= ST2_WR_INIT;
                    end else begin
                        poll_to <= 32'd0;
                        st      <= ST_72B_RD_18; // 再来一轮
                    end
                end

                // ====================================================
                // Stage2: mem-bridge 写 66/61/73/49
                // ====================================================
                ST2_WR_INIT: begin
                    wr2_idx     <= 2'd0;
                    wr_wait_cnt <= 32'd0;
                    st          <= ST2_WR_18;
                end

                ST2_WR_18: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h18, 8'h80);
                    st <= ST2_WR_18_W;
                end
                ST2_WR_18_W: if (rsp_valid) begin
                    st <= ST2_WR_19;
                end

                ST2_WR_19: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h19, wr2_low_addr(wr2_idx));
                    st <= ST2_WR_19_W;
                end
                ST2_WR_19_W: if (rsp_valid) begin
                    st <= ST2_WR_13;
                end

                ST2_WR_13: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h13, wr2_data(wr2_idx));
                    st <= ST2_WR_13_W;
                end
                ST2_WR_13_W: if (rsp_valid) begin
                    st <= ST2_WR_17_01;
                end

                ST2_WR_17_01: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h01);
                    st <= ST2_WR_17_01_W;
                end
                ST2_WR_17_01_W: if (rsp_valid) begin
                    wr_wait_cnt <= 32'd0;
                    st          <= ST2_WR_WAIT;
                end

                ST2_WR_WAIT: begin
                    if (wr_wait_cnt >= WR_WAIT_CYCLES) begin
                        st <= ST2_WR_17_CLR;
                    end else begin
                        wr_wait_cnt <= wr_wait_cnt + 1'b1;
                    end
                end

                ST2_WR_17_CLR: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h00);
                    st <= ST2_WR_17_CLR_W;
                end
                ST2_WR_17_CLR_W: if (rsp_valid) begin
                    st <= ST2_WR_NEXT;
                end

                ST2_WR_NEXT: begin
                    if (wr2_idx == 2'd3) begin
                        rd2_idx <= 2'd0;
                        poll_to <= 32'd0;
                        st      <= ST2_RD_INIT;
                    end else begin
                        wr2_idx <= wr2_idx + 1'b1;
                        st      <= ST2_WR_18;
                    end
                end

                // ====================================================
                // Stage2: mem_readback 读 69/64/73/49
                // ====================================================
                ST2_RD_INIT: begin
                    poll_to <= 32'd0;
                    st      <= ST2_RD_18;
                end

                ST2_RD_18: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h18, 8'h80);
                    st <= ST2_RD_18_W;
                end
                ST2_RD_18_W: if (rsp_valid) begin
                    st <= ST2_RD_19;
                end

                ST2_RD_19: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h19, rd2_low_addr(rd2_idx));
                    st <= ST2_RD_19_W;
                end
                ST2_RD_19_W: if (rsp_valid) begin
                    st <= ST2_RD_17_02;
                end

                ST2_RD_17_02: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h02);
                    st <= ST2_RD_17_02_W;
                end
                ST2_RD_17_02_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST2_RD_P14_CMD;
                end

                ST2_RD_P14_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h14, 8'h00);
                    st <= ST2_RD_P14_WAIT;
                end
                ST2_RD_P14_WAIT: if (rsp_valid) begin
                    reg14 <= rsp_rdata;
                    if (rsp_rdata[2]) begin
                        st <= ST2_RD_15_CMD;
                    end else if (poll_to >= POLL_TIMEOUT) begin
                        st <= ST_ERR;
                    end else begin
                        poll_to <= poll_to + 1'b1;
                        st      <= ST2_RD_P14_CMD;
                    end
                end

                ST2_RD_15_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h15, 8'h00);
                    st <= ST2_RD_15_WAIT;
                end
                ST2_RD_15_WAIT: if (rsp_valid) begin
                    case (rd2_idx)
                        2'd0: pif69_data <= rsp_rdata;
                        2'd1: pif64_data <= rsp_rdata;
                        2'd2: pif73_data <= rsp_rdata;
                        2'd3: pif49_data <= rsp_rdata;
                        default: ;
                    endcase
                    st <= ST2_RD_17_CLR;
                end

                ST2_RD_17_CLR: if (cmd_ready) begin
                    issue_cmd(1'b1, 8'h17, 8'h00);
                    st <= ST2_RD_17_CLR_W;
                end
                ST2_RD_17_CLR_W: if (rsp_valid) begin
                    poll_to <= 32'd0;
                    st      <= ST2_FLUSH_P14_CMD;
                end

                ST2_FLUSH_P14_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h14, 8'h00);
                    st <= ST2_FLUSH_P14_WAIT;
                end
                ST2_FLUSH_P14_WAIT: if (rsp_valid) begin
                    reg14 <= rsp_rdata;
                    if (rsp_rdata[2]) begin
                        st <= ST2_FLUSH_15_CMD;
                    end else if (poll_to >= POLL_TIMEOUT) begin
                        st <= ST_ERR;
                    end else begin
                        st <= ST2_RD_NEXT;
                    end
                end

                ST2_FLUSH_15_CMD: if (cmd_ready) begin
                    issue_cmd(1'b0, 8'h15, 8'h00);
                    st <= ST2_FLUSH_15_WAIT;
                end
                ST2_FLUSH_15_WAIT: if (rsp_valid) begin
                    poll_to <= poll_to + 1'b1;
                    st      <= ST2_FLUSH_P14_CMD;
                end

                ST2_RD_NEXT: begin
                    if (rd2_idx == 2'd3) begin
                        st <= ST_DONE;
                    end else begin
                        rd2_idx <= rd2_idx + 1'b1;
                        poll_to <= 32'd0;
                        st      <= ST2_RD_18;
                    end
                end

                ST_DONE: begin
                    st <= ST_DONE;
                end

                ST_ERR: begin
                    st <= ST_ERR;
                end

                default: st <= ST_ERR;
            endcase
        end
    end

    // ---------------- Debug / ILA probes ----------------
    (* mark_debug="true" *) reg [7:0] st_dbg;
    (* mark_debug="true" *) reg [7:0] reg14_dbg;
    (* mark_debug="true" *) reg [7:0] pif76_dbg, pif78_dbg, pif7A_dbg, pif7B_dbg, pif7E_dbg;
    (* mark_debug="true" *) reg [7:0] pif4A_dbg, pif72_xosc_dbg, pif72_cpll_dbg;
    (* mark_debug="true" *) reg [7:0] pif69_dbg, pif64_dbg, pif73_dbg, pif49_dbg;
    (* mark_debug="true" *) reg [15:0] last_tx16_dbg, last_rx16_dbg;
    (* mark_debug="true" *) reg        cs_dbg, sck_dbg, mosi_dbg, miso_dbg;

    always @(posedge clk_100m) begin
        st_dbg        <= st;
        reg14_dbg     <= reg14;

        pif76_dbg     <= pif76_data;
        pif78_dbg     <= pif78_data;
        pif7A_dbg     <= pif7A_data;
        pif7B_dbg     <= pif7B_data;
        pif7E_dbg     <= pif7E_data;

        pif4A_dbg        <= pif4A_data;
        pif72_xosc_dbg   <= pif72_xosc_data;
        pif72_cpll_dbg   <= pif72_cpll_data;

        pif69_dbg     <= pif69_data;
        pif64_dbg     <= pif64_data;
        pif73_dbg     <= pif73_data;
        pif49_dbg     <= pif49_data;

        last_tx16_dbg <= last_tx16_w;
        last_rx16_dbg <= last_rx16_w;

        cs_dbg   <= spi_cs_n;
        sck_dbg  <= spi_sck;
        mosi_dbg <= spi_mosi;
        miso_dbg <= spi_miso;
    end

endmodule
