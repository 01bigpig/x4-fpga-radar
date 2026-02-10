// ============================================================
// spi_xfer16_mode0.v
// 16-bit SPI transfer core, Mode0 (CPOL=0, CPHA=0), MSB-first
// - CS stays low for the entire 16-bit transaction
// - Sample MISO on rising edge
// - Shift MOSI on falling edge
// F_sck = F_clk / (2*CLK_DIV)
// ============================================================
module spi_xfer16_mode0 #(
    parameter integer CLK_DIV = 5
)(
    input  wire        clk,
    input  wire        rst_n,

    input  wire        start,     // 1-cycle pulse
    input  wire [15:0] tx16,
    output reg  [15:0] rx16,

    output reg         busy,
    output reg         done,      // 1-cycle pulse

    output reg         sck,
    output wire        mosi,
    input  wire        miso,
    output reg         cs_n
);
    localparam integer DIV_W = (CLK_DIV <= 1) ? 1 : $clog2(CLK_DIV);

    reg [DIV_W-1:0] div_cnt;
    reg [4:0]       bit_cnt;      // 15..0
    reg [15:0]      sh_tx, sh_rx;

    assign mosi = sh_tx[15];

    localparam ST_IDLE = 1'b0;
    localparam ST_RUN  = 1'b1;
    reg state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= ST_IDLE;
            div_cnt <= {DIV_W{1'b0}};
            bit_cnt <= 5'd0;
            sh_tx   <= 16'h0000;
            sh_rx   <= 16'h0000;
            rx16    <= 16'h0000;
            busy    <= 1'b0;
            done    <= 1'b0;
            sck     <= 1'b0;
            cs_n    <= 1'b1;
        end else begin
            done <= 1'b0;

            case (state)
                ST_IDLE: begin
                    busy    <= 1'b0;
                    sck     <= 1'b0;
                    cs_n    <= 1'b1;
                    div_cnt <= {DIV_W{1'b0}};

                    if (start) begin
                        sh_tx   <= tx16;
                        sh_rx   <= 16'h0000;
                        bit_cnt <= 5'd15;

                        busy <= 1'b1;
                        cs_n <= 1'b0;
                        sck  <= 1'b0;

                        state <= ST_RUN;
                    end
                end

                ST_RUN: begin
                    busy <= 1'b1;
                    cs_n <= 1'b0;

                    if (div_cnt == CLK_DIV-1) begin
                        div_cnt <= {DIV_W{1'b0}};
                        sck     <= ~sck;

                        if (sck == 1'b0) begin
                            // rising edge: sample MISO
                            sh_rx <= {sh_rx[14:0], miso};
                        end else begin
                            // falling edge: shift TX, decrement bit counter
                            sh_tx <= {sh_tx[14:0], 1'b0};

                            if (bit_cnt == 5'd0) begin
                                rx16  <= sh_rx;   // sh_rx 已包含最后一次 rising edge 采样
                                cs_n  <= 1'b1;
                                sck   <= 1'b0;
                                busy  <= 1'b0;
                                done  <= 1'b1;
                                state <= ST_IDLE;
                            end else begin
                                bit_cnt <= bit_cnt - 1'b1;
                            end
                        end
                    end else begin
                        div_cnt <= div_cnt + 1'b1;
                    end
                end

                default: state <= ST_IDLE;
            endcase
        end
    end

endmodule