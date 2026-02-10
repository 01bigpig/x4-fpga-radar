// ============================================================
// radar_ctrl_top.v
//
// SPI shared by:
//   0) top_x4_pif_init_membridge -> init_done
//   1) sweep reg_service (mem-bridge strict template)
//   2) x4_spi_burst_reader -> BRAM PortB writes
//
// Flow:
//  1) INIT, wait init_done
//  2) write 0x2B=FF, write 0x36=FF
//  3) poll read 0x3A until bit0==1
//     - AFTER read 0x3A: do cleanup flush, BUT limit to 10 loops
//       if still not empty after 10 loops -> jump to 0x42 (T_CHECK_DONE)
//  4) read 0x27 -> invert bit0 -> write back 0x27
//  5) write 0x1D=FF then read back 0x1D (strict read + flush)
//  6) start burst reader
//  7) loop
// ============================================================

module radar_ctrl_top #(
    parameter integer CLK_DIV_BURST     = 5,
    parameter integer BURST_BYTE_COUNT  = 9216,

    // Stage5A
    parameter [7:0] PIF_RESET_CNTR_ADDR = 8'h2B,
    parameter [7:0] PIF_TRX_START_ADDR  = 8'h36,
    parameter [7:0] PIF_DONE_ADDR       = 8'h3A,

    // Prepare read (ram_select)
    parameter [7:0] PIF_RAMSEL_ADDR     = 8'h27,

    // New: PIF 0x1D
    parameter [7:0] PIF_1D_ADDR         = 8'h1D,

    // mem-bridge template timing
    parameter integer WR_WAIT_CYCLES    = 32'd50_000,    // ~0.5ms @100MHz
    parameter integer POLL_TIMEOUT      = 32'd5_000_000  // ~50ms
)(
    input  wire clk_100m,

    // physical SPI
    output wire spi_sck,
    output wire spi_mosi,
    input  wire spi_miso,
    output wire spi_cs_n,

    // connect to blk_mem_gen_0 PortB
    output wire [11:0] bram_addrb,
    output wire        bram_clkb,
    output wire        bram_enb,
    output wire [3:0]  bram_web,
    output wire [31:0] bram_dinb,
    input  wire [31:0] bram_doutb,
    output wire        bram_rstb
);

    // ============================================================
    // BRAM clk/rst
    // ============================================================
    assign bram_clkb = clk_100m;

    // ---------------- POR reset ----------------
    localparam integer POR_CYCLES = 32'd5_000_000; // ~50ms @100MHz
    reg [31:0] por_cnt = 32'd0;
    reg        rst_n_r  = 1'b0;
    wire       rst_n    = rst_n_r;

    assign bram_rstb = ~rst_n;

    always @(posedge clk_100m) begin
        if (!rst_n_r) begin
            if (por_cnt >= POR_CYCLES) rst_n_r <= 1'b1;
            else por_cnt <= por_cnt + 1'b1;
        end
    end

    // ============================================================
    // 0) INIT
    // ============================================================
    wire init_done;
    wire init_sck, init_mosi, init_cs_n;

    top_x4_pif_init_membridge u_init (
        .clk_100m (clk_100m),
        .spi_sck  (init_sck),
        .spi_mosi (init_mosi),
        .spi_miso (spi_miso),
        .spi_cs_n (init_cs_n),
        .init_done(init_done)
    );

    // ============================================================
    // 1) SWEEP reg service
    // ============================================================
    wire sweep_sck, sweep_mosi, sweep_cs_n;

    reg        sc_cmd_valid;
    reg        sc_cmd_write;
    reg [7:0]  sc_cmd_addr;
    reg [7:0]  sc_cmd_wdata;
    wire       sc_cmd_ready;

    wire       sc_rsp_valid;
    wire [7:0] sc_rsp_rdata;

    x4_spi_reg_service #(.CLK_DIV(5)) u_sweep_srv (
        .clk       (clk_100m),
        .rst_n     (rst_n),

        .cmd_valid (sc_cmd_valid),
        .cmd_write (sc_cmd_write),
        .cmd_addr  (sc_cmd_addr),
        .cmd_wdata (sc_cmd_wdata),
        .cmd_ready (sc_cmd_ready),

        .rsp_valid (sc_rsp_valid),
        .rsp_rdata (sc_rsp_rdata),

        .spi_sck   (sweep_sck),
        .spi_mosi  (sweep_mosi),
        .spi_miso  (spi_miso),
        .spi_cs_n  (sweep_cs_n),

        .last_tx16 (),
        .last_rx16 ()
    );

    task issue_sc_cmd;
        input        w;
        input [7:0]  a;
        input [7:0]  d;
        begin
            sc_cmd_write <= w;
            sc_cmd_addr  <= a;
            sc_cmd_wdata <= d;
            sc_cmd_valid <= 1'b1;
        end
    endtask

    // ============================================================
    // 2) BURST reader
    // ============================================================
    wire burst_sck, burst_mosi, burst_cs_n;
    (* mark_debug = "true" *) reg  burst_start;
    wire burst_busy;
    wire burst_done;

    x4_spi_burst_reader #(
        .CLK_DIV    (CLK_DIV_BURST),
        .BYTE_COUNT (BURST_BYTE_COUNT)
    ) u_burst (
        .clk         (clk_100m),
        .rst_n       (rst_n),
        .start_frame (burst_start),
        .busy        (burst_busy),
        .frame_done  (burst_done),

        .byte_valid  (),
        .byte_data   (),

        .bram_addr   (bram_addrb),
        .bram_en     (bram_enb),
        .bram_we     (bram_web),
        .bram_din    (bram_dinb),

        .spi_sck     (burst_sck),
        .spi_mosi    (burst_mosi),
        .spi_miso    (spi_miso),
        .spi_cs_n    (burst_cs_n)
    );

    // ============================================================
    // SPI MUX: 0=INIT, 1=SWEEP, 2=BURST
    // ============================================================
    reg [1:0] spi_sel;

    assign spi_sck  = (spi_sel == 2'd0) ? init_sck  :
                      (spi_sel == 2'd1) ? sweep_sck :
                                          burst_sck;

    assign spi_mosi = (spi_sel == 2'd0) ? init_mosi :
                      (spi_sel == 2'd1) ? sweep_mosi:
                                          burst_mosi;

    assign spi_cs_n = (spi_sel == 2'd0) ? init_cs_n :
                      (spi_sel == 2'd1) ? sweep_cs_n:
                                          burst_cs_n;

    // ============================================================
    // Top-level scheduler FSM
    // ============================================================
    localparam [7:0]
        T_IDLE          = 8'd0,
        T_WAIT_INIT     = 8'd1,

        // write 2B=FF
        T_WR2B_18       = 8'd10,  T_WR2B_18_W = 8'd11,
        T_WR2B_19       = 8'd12,  T_WR2B_19_W = 8'd13,
        T_WR2B_13       = 8'd14,  T_WR2B_13_W = 8'd15,
        T_WR2B_17_01    = 8'd16,  T_WR2B_17_01_W = 8'd17,
        T_WR2B_WAIT     = 8'd18,
        T_WR2B_17_00    = 8'd19,  T_WR2B_17_00_W = 8'd20,

        // write 36=FF
        T_WR36_18       = 8'd30,  T_WR36_18_W = 8'd31,
        T_WR36_19       = 8'd32,  T_WR36_19_W = 8'd33,
        T_WR36_13       = 8'd34,  T_WR36_13_W = 8'd35,
        T_WR36_17_01    = 8'd36,  T_WR36_17_01_W = 8'd37,
        T_WR36_WAIT     = 8'd38,
        T_WR36_17_00    = 8'd39,  T_WR36_17_00_W = 8'd40,

        // read 3A poll
        T_RD3A_18        = 8'd50,  T_RD3A_18_W = 8'd51,
        T_RD3A_19        = 8'd52,  T_RD3A_19_W = 8'd53,
        T_RD3A_17_02     = 8'd54,  T_RD3A_17_02_W = 8'd55,
        T_RD3A_P14_CMD   = 8'd56,  T_RD3A_P14_WAIT = 8'd57,
        T_RD3A_15_CMD    = 8'd58,  T_RD3A_15_WAIT  = 8'd59,
        T_RD3A_17_00     = 8'd60,  T_RD3A_17_00_W  = 8'd61,

        // 0x3A 后清理 flush（限制 10 次）
        T_FLUSH_P14_CMD  = 8'd62,  T_FLUSH_P14_WAIT= 8'd63,
        T_FLUSH_15_CMD   = 8'd64,  T_FLUSH_15_WAIT = 8'd65,
        T_CHECK_DONE     = 8'd66,  // <<< 66(dec) == 0x42(hex)

        // read 27
        T_RD27_18             = 8'd70,  T_RD27_18_W = 8'd71,
        T_RD27_19             = 8'd72,  T_RD27_19_W = 8'd73,
        T_RD27_17_02          = 8'd74,  T_RD27_17_02_W = 8'd75,
        T_RD27_P14_CMD        = 8'd76,  T_RD27_P14_WAIT = 8'd77,
        T_RD27_15_CMD         = 8'd78,  T_RD27_15_WAIT  = 8'd79,
        T_RD27_17_00          = 8'd80,  T_RD27_17_00_W  = 8'd81,
        T_RD27_FLUSH_P14_CMD  = 8'd82,  T_RD27_FLUSH_P14_WAIT = 8'd83,
        T_RD27_FLUSH_15_CMD   = 8'd84,  T_RD27_FLUSH_15_WAIT  = 8'd85,
        T_RD27_MAKE_NEW       = 8'd86,

        // write 27
        T_WR27_18             = 8'd90,  T_WR27_18_W = 8'd91,
        T_WR27_19             = 8'd92,  T_WR27_19_W = 8'd93,
        T_WR27_13             = 8'd94,  T_WR27_13_W = 8'd95,
        T_WR27_17_01          = 8'd96,  T_WR27_17_01_W = 8'd97,
        T_WR27_WAIT           = 8'd98,
        T_WR27_17_00          = 8'd99,  T_WR27_17_00_W = 8'd100,

        // write 1D=FF
        T_WR1D_18             = 8'd130, T_WR1D_18_W = 8'd131,
        T_WR1D_19             = 8'd132, T_WR1D_19_W = 8'd133,
        T_WR1D_13             = 8'd134, T_WR1D_13_W = 8'd135,
        T_WR1D_17_01          = 8'd136, T_WR1D_17_01_W = 8'd137,
        T_WR1D_WAIT           = 8'd138,
        T_WR1D_17_00          = 8'd139, T_WR1D_17_00_W = 8'd140,

        // read 1D
        T_RD1D_18             = 8'd150, T_RD1D_18_W = 8'd151,
        T_RD1D_19             = 8'd152, T_RD1D_19_W = 8'd153,
        T_RD1D_17_02          = 8'd154, T_RD1D_17_02_W = 8'd155,
        T_RD1D_P14_CMD        = 8'd156, T_RD1D_P14_WAIT = 8'd157,
        T_RD1D_15_CMD         = 8'd158, T_RD1D_15_WAIT  = 8'd159,
        T_RD1D_17_00          = 8'd160, T_RD1D_17_00_W  = 8'd161,
        T_RD1D_FLUSH_P14_CMD  = 8'd162, T_RD1D_FLUSH_P14_WAIT = 8'd163,
        T_RD1D_FLUSH_15_CMD   = 8'd164, T_RD1D_FLUSH_15_WAIT  = 8'd165,
        T_RD1D_DONE           = 8'd166,

        // burst
        T_START_BURST    = 8'd110,
        T_WAIT_BURST     = 8'd111,

        T_LOOP          = 8'd120,
        T_ERR           = 8'd255;

    reg [7:0]  t_st;

    reg [31:0] wr_wait_cnt;
    reg [31:0] poll_to;
    reg [7:0]  reg14;

    reg [7:0]  pif3A_data;
    reg [7:0]  pif27_data;
    reg [7:0]  pif27_new;
    reg [7:0]  pif1D_data;

    // ============================================================
    // NEW: 0x3A 后 flush 次数限制（最多 10 次）
    // ============================================================
    reg [3:0] flush3a_cnt;

    always @(posedge clk_100m or negedge rst_n) begin
        if (!rst_n) begin
            t_st <= T_IDLE;

            spi_sel     <= 2'd0;
            burst_start <= 1'b0;

            sc_cmd_valid <= 1'b0;
            sc_cmd_write <= 1'b0;
            sc_cmd_addr  <= 8'h00;
            sc_cmd_wdata <= 8'h00;

            wr_wait_cnt  <= 32'd0;
            poll_to      <= 32'd0;
            reg14        <= 8'h00;

            pif3A_data   <= 8'h00;
            pif27_data   <= 8'h00;
            pif27_new    <= 8'h00;
            pif1D_data   <= 8'h00;

            flush3a_cnt  <= 4'd0;

        end else begin
            // defaults
            sc_cmd_valid <= 1'b0;
            burst_start  <= 1'b0;

            case (t_st)

                T_IDLE: begin
                    spi_sel <= 2'd0;
                    t_st    <= T_WAIT_INIT;
                end

                T_WAIT_INIT: begin
                    spi_sel <= 2'd0;
                    if (init_done) begin
                        spi_sel <= 2'd1;
                        t_st    <= T_WR2B_18;
                    end
                end

                // ---------------- write 2B=FF ----------------
                T_WR2B_18: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h18,8'h80); t_st<=T_WR2B_18_W; end
                T_WR2B_18_W: if (sc_rsp_valid) t_st<=T_WR2B_19;
                T_WR2B_19: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h19,PIF_RESET_CNTR_ADDR); t_st<=T_WR2B_19_W; end
                T_WR2B_19_W: if (sc_rsp_valid) t_st<=T_WR2B_13;
                T_WR2B_13: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h13,8'hFF); t_st<=T_WR2B_13_W; end
                T_WR2B_13_W: if (sc_rsp_valid) t_st<=T_WR2B_17_01;
                T_WR2B_17_01: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h01); t_st<=T_WR2B_17_01_W; end
                T_WR2B_17_01_W: if (sc_rsp_valid) begin wr_wait_cnt<=0; t_st<=T_WR2B_WAIT; end
                T_WR2B_WAIT: begin
                    if (wr_wait_cnt>=WR_WAIT_CYCLES) t_st<=T_WR2B_17_00;
                    else wr_wait_cnt<=wr_wait_cnt+1;
                end
                T_WR2B_17_00: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h00); t_st<=T_WR2B_17_00_W; end
                T_WR2B_17_00_W: if (sc_rsp_valid) t_st<=T_WR36_18;

                // ---------------- write 36=FF ----------------
                T_WR36_18: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h18,8'h80); t_st<=T_WR36_18_W; end
                T_WR36_18_W: if (sc_rsp_valid) t_st<=T_WR36_19;
                T_WR36_19: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h19,PIF_TRX_START_ADDR); t_st<=T_WR36_19_W; end
                T_WR36_19_W: if (sc_rsp_valid) t_st<=T_WR36_13;
                T_WR36_13: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h13,8'hFF); t_st<=T_WR36_13_W; end
                T_WR36_13_W: if (sc_rsp_valid) t_st<=T_WR36_17_01;
                T_WR36_17_01: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h01); t_st<=T_WR36_17_01_W; end
                T_WR36_17_01_W: if (sc_rsp_valid) begin wr_wait_cnt<=0; t_st<=T_WR36_WAIT; end
                T_WR36_WAIT: begin
                    if (wr_wait_cnt>=WR_WAIT_CYCLES) t_st<=T_WR36_17_00;
                    else wr_wait_cnt<=wr_wait_cnt+1;
                end
                T_WR36_17_00: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h00); t_st<=T_WR36_17_00_W; end
                T_WR36_17_00_W: if (sc_rsp_valid) begin poll_to<=0; t_st<=T_RD3A_18; end

                // ---------------- poll read 3A ----------------
                T_RD3A_18: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h18,8'h80); t_st<=T_RD3A_18_W; end
                T_RD3A_18_W: if (sc_rsp_valid) t_st<=T_RD3A_19;
                T_RD3A_19: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h19,PIF_DONE_ADDR); t_st<=T_RD3A_19_W; end
                T_RD3A_19_W: if (sc_rsp_valid) t_st<=T_RD3A_17_02;
                T_RD3A_17_02: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h02); t_st<=T_RD3A_17_02_W; end
                T_RD3A_17_02_W: if (sc_rsp_valid) begin poll_to<=0; t_st<=T_RD3A_P14_CMD; end

                T_RD3A_P14_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h14,8'h00); t_st<=T_RD3A_P14_WAIT; end
                T_RD3A_P14_WAIT: if (sc_rsp_valid) begin
                    reg14 <= sc_rsp_rdata;
                    if (sc_rsp_rdata[2]) t_st <= T_RD3A_15_CMD;
                    else if (poll_to >= POLL_TIMEOUT) t_st <= T_ERR;
                    else begin poll_to <= poll_to + 1; t_st <= T_RD3A_P14_CMD; end
                end

                T_RD3A_15_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h15,8'h00); t_st<=T_RD3A_15_WAIT; end
                T_RD3A_15_WAIT: if (sc_rsp_valid) begin
                    pif3A_data <= sc_rsp_rdata;
                    t_st       <= T_RD3A_17_00;
                end

                // 你要求保持：读完 0x15 -> 17=00 -> flush
                T_RD3A_17_00: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h00); t_st<=T_RD3A_17_00_W; end
                T_RD3A_17_00_W: if (sc_rsp_valid) begin
                    poll_to     <= 0;
                    flush3a_cnt <= 0;              // <<< 进入 flush 清零计数
                    t_st        <= T_FLUSH_P14_CMD;
                end

                // ---------------- flush readback FIFO (LIMIT 10 loops) ----------------
                T_FLUSH_P14_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h14,8'h00); t_st<=T_FLUSH_P14_WAIT; end
                T_FLUSH_P14_WAIT: if (sc_rsp_valid) begin
                    reg14 <= sc_rsp_rdata;
                    if (sc_rsp_rdata[2]) t_st <= T_FLUSH_15_CMD;
                    else if (poll_to >= POLL_TIMEOUT) t_st <= T_ERR;
                    else t_st <= T_CHECK_DONE;     // empty -> done
                end

                T_FLUSH_15_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h15,8'h00); t_st<=T_FLUSH_15_WAIT; end
                T_FLUSH_15_WAIT: if (sc_rsp_valid) begin
                    // 每做一次 flush(读15) 记一次数
                    if (flush3a_cnt >= 4'd9) begin
                        // 10 次还没刷干净 -> 跳到 0x42 (T_CHECK_DONE)
                        t_st <= T_CHECK_DONE;
                    end else begin
                        flush3a_cnt <= flush3a_cnt + 1'b1;
                        poll_to     <= poll_to + 1;
                        t_st        <= T_FLUSH_P14_CMD;
                    end
                end

                T_CHECK_DONE: begin
                    if (pif3A_data[0]) t_st <= T_RD27_18;
                    else begin
                        poll_to <= 0;
                        t_st    <= T_RD3A_18; // retry poll
                    end
                end

                // ============================================================
                // READ 0x27 (strict read template + flush), then invert, then write back
                // ============================================================
                T_RD27_18: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h18,8'h80); t_st<=T_RD27_18_W; end
                T_RD27_18_W: if (sc_rsp_valid) t_st<=T_RD27_19;

                T_RD27_19: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h19,PIF_RAMSEL_ADDR); t_st<=T_RD27_19_W; end
                T_RD27_19_W: if (sc_rsp_valid) t_st<=T_RD27_17_02;

                T_RD27_17_02: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h02); t_st<=T_RD27_17_02_W; end
                T_RD27_17_02_W: if (sc_rsp_valid) begin poll_to<=0; t_st<=T_RD27_P14_CMD; end

                T_RD27_P14_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h14,8'h00); t_st<=T_RD27_P14_WAIT; end
                T_RD27_P14_WAIT: if (sc_rsp_valid) begin
                    reg14 <= sc_rsp_rdata;
                    if (sc_rsp_rdata[2]) t_st <= T_RD27_15_CMD;
                    else if (poll_to >= POLL_TIMEOUT) t_st <= T_ERR;
                    else begin poll_to <= poll_to + 1; t_st <= T_RD27_P14_CMD; end
                end

                T_RD27_15_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h15,8'h00); t_st<=T_RD27_15_WAIT; end
                T_RD27_15_WAIT: if (sc_rsp_valid) begin
                    pif27_data <= sc_rsp_rdata;
                    t_st       <= T_RD27_17_00;
                end

                T_RD27_17_00: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h00); t_st<=T_RD27_17_00_W; end
                T_RD27_17_00_W: if (sc_rsp_valid) begin poll_to<=0; t_st<=T_RD27_FLUSH_P14_CMD; end

                T_RD27_FLUSH_P14_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h14,8'h00); t_st<=T_RD27_FLUSH_P14_WAIT; end
                T_RD27_FLUSH_P14_WAIT: if (sc_rsp_valid) begin
                    reg14 <= sc_rsp_rdata;
                    if (sc_rsp_rdata[2]) t_st <= T_RD27_FLUSH_15_CMD;
                    else if (poll_to >= POLL_TIMEOUT) t_st <= T_ERR;
                    else t_st <= T_RD27_MAKE_NEW;
                end

                T_RD27_FLUSH_15_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h15,8'h00); t_st<=T_RD27_FLUSH_15_WAIT; end
                T_RD27_FLUSH_15_WAIT: if (sc_rsp_valid) begin
                    poll_to <= poll_to + 1;
                    t_st    <= T_RD27_FLUSH_P14_CMD;
                end

                T_RD27_MAKE_NEW: begin
                    pif27_new <= pif27_data ^ 8'h01; // flip bit0
                    t_st      <= T_WR27_18;
                end

                // write 0x27 = pif27_new
                T_WR27_18: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h18,8'h80); t_st<=T_WR27_18_W; end
                T_WR27_18_W: if (sc_rsp_valid) t_st<=T_WR27_19;

                T_WR27_19: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h19,PIF_RAMSEL_ADDR); t_st<=T_WR27_19_W; end
                T_WR27_19_W: if (sc_rsp_valid) t_st<=T_WR27_13;

                T_WR27_13: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h13,pif27_new); t_st<=T_WR27_13_W; end
                T_WR27_13_W: if (sc_rsp_valid) t_st<=T_WR27_17_01;

                T_WR27_17_01: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h01); t_st<=T_WR27_17_01_W; end
                T_WR27_17_01_W: if (sc_rsp_valid) begin wr_wait_cnt<=0; t_st<=T_WR27_WAIT; end

                T_WR27_WAIT: begin
                    if (wr_wait_cnt>=WR_WAIT_CYCLES) t_st<=T_WR27_17_00;
                    else wr_wait_cnt<=wr_wait_cnt+1;
                end

                T_WR27_17_00: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h00); t_st<=T_WR27_17_00_W; end
                T_WR27_17_00_W: if (sc_rsp_valid) t_st<=T_WR1D_18;

                // ============================================================
                // WRITE 0x1D = 0xFF
                // ============================================================
                T_WR1D_18: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h18,8'h80); t_st<=T_WR1D_18_W; end
                T_WR1D_18_W: if (sc_rsp_valid) t_st<=T_WR1D_19;

                T_WR1D_19: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h19,PIF_1D_ADDR); t_st<=T_WR1D_19_W; end
                T_WR1D_19_W: if (sc_rsp_valid) t_st<=T_WR1D_13;

                T_WR1D_13: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h13,8'hFF); t_st<=T_WR1D_13_W; end
                T_WR1D_13_W: if (sc_rsp_valid) t_st<=T_WR1D_17_01;

                T_WR1D_17_01: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h01); t_st<=T_WR1D_17_01_W; end
                T_WR1D_17_01_W: if (sc_rsp_valid) begin wr_wait_cnt<=0; t_st<=T_WR1D_WAIT; end

                T_WR1D_WAIT: begin
                    if (wr_wait_cnt>=WR_WAIT_CYCLES) t_st<=T_WR1D_17_00;
                    else wr_wait_cnt<=wr_wait_cnt+1;
                end

                T_WR1D_17_00: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h00); t_st<=T_WR1D_17_00_W; end
                T_WR1D_17_00_W: if (sc_rsp_valid) begin poll_to<=0; t_st<=T_RD1D_18; end

                // ============================================================
                // READ 0x1D (read -> 17=00 -> flush)
                // ============================================================
                T_RD1D_18: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h18,8'h80); t_st<=T_RD1D_18_W; end
                T_RD1D_18_W: if (sc_rsp_valid) t_st<=T_RD1D_19;

                T_RD1D_19: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h19,PIF_1D_ADDR); t_st<=T_RD1D_19_W; end
                T_RD1D_19_W: if (sc_rsp_valid) t_st<=T_RD1D_17_02;

                T_RD1D_17_02: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h02); t_st<=T_RD1D_17_02_W; end
                T_RD1D_17_02_W: if (sc_rsp_valid) begin poll_to<=0; t_st<=T_RD1D_P14_CMD; end

                T_RD1D_P14_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h14,8'h00); t_st<=T_RD1D_P14_WAIT; end
                T_RD1D_P14_WAIT: if (sc_rsp_valid) begin
                    reg14 <= sc_rsp_rdata;
                    if (sc_rsp_rdata[2]) t_st <= T_RD1D_15_CMD;
                    else if (poll_to >= POLL_TIMEOUT) t_st <= T_ERR;
                    else begin poll_to <= poll_to + 1; t_st <= T_RD1D_P14_CMD; end
                end

                T_RD1D_15_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h15,8'h00); t_st<=T_RD1D_15_WAIT; end
                T_RD1D_15_WAIT: if (sc_rsp_valid) begin
                    pif1D_data <= sc_rsp_rdata;
                    t_st       <= T_RD1D_17_00;
                end

                T_RD1D_17_00: if (sc_cmd_ready) begin issue_sc_cmd(1'b1,8'h17,8'h00); t_st<=T_RD1D_17_00_W; end
                T_RD1D_17_00_W: if (sc_rsp_valid) begin poll_to<=0; t_st<=T_RD1D_FLUSH_P14_CMD; end

                T_RD1D_FLUSH_P14_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h14,8'h00); t_st<=T_RD1D_FLUSH_P14_WAIT; end
                T_RD1D_FLUSH_P14_WAIT: if (sc_rsp_valid) begin
                    reg14 <= sc_rsp_rdata;
                    if (sc_rsp_rdata[2]) t_st <= T_RD1D_FLUSH_15_CMD;
                    else if (poll_to >= POLL_TIMEOUT) t_st <= T_ERR;
                    else t_st <= T_RD1D_DONE;
                end

                T_RD1D_FLUSH_15_CMD: if (sc_cmd_ready) begin issue_sc_cmd(1'b0,8'h15,8'h00); t_st<=T_RD1D_FLUSH_15_WAIT; end
                T_RD1D_FLUSH_15_WAIT: if (sc_rsp_valid) begin
                    poll_to <= poll_to + 1;
                    t_st    <= T_RD1D_FLUSH_P14_CMD;
                end

                T_RD1D_DONE: begin
                    t_st <= T_START_BURST;
                end

                // ---------------- burst ----------------
                T_START_BURST: begin
                    spi_sel <= 2'd2;
                    if (!burst_busy) begin
                        burst_start <= 1'b1;
                        t_st <= T_WAIT_BURST;
                    end
                end

                T_WAIT_BURST: begin
                    spi_sel <= 2'd2;
                    if (burst_done) begin
                        spi_sel <= 2'd1;
                        t_st <= T_LOOP;
                    end
                end

                T_LOOP: begin
                    t_st <= T_WR2B_18;
                end

                T_ERR: begin
                    t_st <= T_ERR;
                end

                default: t_st <= T_ERR;
            endcase
        end
    end

    // ---------------- minimal debug ----------------
    (* mark_debug="true" *) wire [7:0] top_fsm_st = t_st;
    (* mark_debug="true" *) wire [1:0] spi_sel_sig = spi_sel;
    (* mark_debug="true" *) wire burst_busy_sig = burst_busy;
    (* mark_debug="true" *) wire burst_done_sig = burst_done;
    (* mark_debug="true" *) wire [3:0] flush3a_cnt_sig = flush3a_cnt;

endmodule
