// ============================================================
// x4_spi_reg_service.v
// Register R/W service over SPI (Novelda X4 style, *按你实测协议*)
// - write: send {0x80 | addr, data}
// - read : send {addr, 8'h00}, return rx16[7:0]
// Handshake:
//   cmd_valid:  在 cmd_ready=1 的那个周期拉高 1clk，提交一条命令
//   cmd_ready:  空闲且底层 SPI 不 busy 时为 1
//   rsp_valid:  一条命令完成时拉高 1clk（读/写都会给）
//   rsp_rdata:  只在读操作时有效（写操作忽略即可）
// ============================================================
module x4_spi_reg_service #(
    parameter integer CLK_DIV = 5
)(
    input  wire        clk,
    input  wire        rst_n,

    input  wire        cmd_valid,      // 上层 1clk 脉冲
    input  wire        cmd_write,      // 1 = write, 0 = read
    input  wire [7:0]  cmd_addr,
    input  wire [7:0]  cmd_wdata,
    output wire        cmd_ready,      // 可以接收下一条命令

    output reg         rsp_valid,      // 1clk 完成脉冲（读写都有）
    output reg  [7:0]  rsp_rdata,      // 读操作时返回的数据

    output wire        spi_sck,
    output wire        spi_mosi,
    input  wire        spi_miso,
    output wire        spi_cs_n,

    output reg  [15:0] last_tx16,
    output reg  [15:0] last_rx16
);

    // ---------------- 底层 16bit SPI ----------------
    reg         start;
    reg  [15:0] tx16;
    wire [15:0] rx16;
    wire        busy, done;

    spi_xfer16_mode0 #(.CLK_DIV(CLK_DIV)) u_spi16 (
        .clk   (clk),
        .rst_n (rst_n),
        .start (start),
        .tx16  (tx16),
        .rx16  (rx16),
        .busy  (busy),
        .done  (done),
        .sck   (spi_sck),
        .mosi  (spi_mosi),
        .miso  (spi_miso),
        .cs_n  (spi_cs_n)
    );

    // ---------------- 简单两态 FSM ----------------
    localparam S_IDLE = 1'b0;
    localparam S_WAIT = 1'b1;
    reg state;

    // 把本次命令的信息 latch 一下
    reg       lat_write;
    reg [7:0] lat_addr;
    reg [7:0] lat_wdata;

    // 只有在空闲且底层 SPI 不 busy 的时候 ready
    assign cmd_ready = (state == S_IDLE) && (!busy);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start     <= 1'b0;
            tx16      <= 16'h0000;
            rsp_valid <= 1'b0;
            rsp_rdata <= 8'h00;
            last_tx16 <= 16'h0000;
            last_rx16 <= 16'h0000;
            state     <= S_IDLE;

            lat_write <= 1'b0;
            lat_addr  <= 8'h00;
            lat_wdata <= 8'h00;
        end else begin
            // 默认不启动、不出 rsp
            start     <= 1'b0;
            rsp_valid <= 1'b0;

            case (state)
                // ---------------- 空闲，等一条新命令 ----------------
                S_IDLE: begin
                    if (cmd_valid && cmd_ready) begin
                        // latch 本次命令
                        lat_write <= cmd_write;
                        lat_addr  <= cmd_addr;
                        lat_wdata <= cmd_wdata;

                        if (cmd_write) begin
                            // 写：{0x80|addr, data}
                            tx16      <= { (8'h80 | cmd_addr), cmd_wdata };
                            last_tx16 <= { (8'h80 | cmd_addr), cmd_wdata };
                        end else begin
                            // 读：{addr, 0x00}
                            tx16      <= { cmd_addr, 8'h00 };
                            last_tx16 <= { cmd_addr, 8'h00 };
                        end

                        start <= 1'b1;    // 拉高 1clk，启动一次 16bit 传输
                        state <= S_WAIT;
                    end
                end

                // ---------------- 等待 SPI 完成 ----------------
                S_WAIT: begin
                    if (done) begin
                        last_rx16 <= rx16;

                        // 读操作：返回低 8bit 数据
                        if (!lat_write) begin
                            rsp_rdata <= rx16[7:0];
                        end

                        rsp_valid <= 1'b1;   // 无论读写，都打一个完成脉冲
                        state     <= S_IDLE;
                    end
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
