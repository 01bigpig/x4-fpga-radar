// ============================================================
// x4_spi_burst_reader.v
// Burst read bytes from X4 over SPI (Mode0) using hold-CS SPI core.
//
// Burst format (single-bit SPI):
//   - Keep CS low for entire burst
//   - First send {CMD, 0x00}
//       -> treat rx16[7:0] as first payload byte (data0)
//   - Then repeatedly send {0x00, 0x00}
//       -> payload bytes come as: rx16[15:8] then rx16[7:0]
//
// Outputs:
//   - byte_valid/byte_data: 1 byte per clk when available (debug/stream)
//   - BRAM write port: pack 4 bytes -> 32-bit write, bram_we=4'hF
// ============================================================
module x4_spi_burst_reader #(
    parameter integer CLK_DIV     = 5,
    parameter integer BYTE_COUNT  = 9216,
    parameter [7:0]   CMD_BYTE    = 8'h05
)(
    input  wire        clk,
    input  wire        rst_n,

    input  wire        start_frame,     // 1clk pulse
    output reg         busy,
    output reg         frame_done,      // 1clk pulse

    output reg         byte_valid,
    output reg  [7:0]  byte_data,

    // ---------------- BRAM write port (32-bit) ----------------
    // bram_addr is WORD address (32-bit words)
    output reg  [11:0] bram_addr,
    output reg         bram_en,
    output reg  [3:0]  bram_we,
    output reg  [31:0] bram_din,

    // SPI pins
    output wire        spi_sck,
    output wire        spi_mosi,
    input  wire        spi_miso,
    output wire        spi_cs_n
);

    // ---------------- SPI16 hold-CS core ----------------
    reg         spi_start;
    reg         spi_hold_cs;
    reg  [15:0] spi_tx16;
    wire [15:0] spi_rx16;
    wire        spi_busy;
    wire        spi_done;

    spi_xfer16_mode0_holdcs #(.CLK_DIV(CLK_DIV)) u_spi16 (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (spi_start),
        .hold_cs (spi_hold_cs),
        .tx16    (spi_tx16),
        .rx16    (spi_rx16),
        .busy    (spi_busy),
        .done    (spi_done),
        .sck     (spi_sck),
        .mosi    (spi_mosi),
        .miso    (spi_miso),
        .cs_n    (spi_cs_n)
    );

    // ---------------- 2-byte output buffer ----------------
    reg [7:0] buf0, buf1;
    reg [1:0] buf_cnt;           // 0..2
    reg [13:0] bytes_rem;        // remaining bytes to RECEIVE+push into buf

    // ---------------- BRAM packer (4 bytes -> 32-bit) ----------------
    reg [1:0]  pack_cnt;         // 0..3
    reg [31:0] pack_word;        // holds partial word

    // ---------------- FSM ----------------
    localparam ST_IDLE = 2'd0;
    localparam ST_CMD  = 2'd1;
    localparam ST_DATA = 2'd2;
    localparam ST_END  = 2'd3;

    reg [1:0] st;

    // helper: buffer free slots
    wire [1:0] buf_free = 2'd2 - buf_cnt;

    // compute how many bytes this next SPI transfer will produce
    wire [1:0] need_bytes_cmd  = 2'd1;
    wire [1:0] need_bytes_data = (bytes_rem >= 14'd2) ? 2'd2 :
                                 (bytes_rem == 14'd1) ? 2'd1 : 2'd0;

    // can start next SPI xfer?
    wire can_start_cmd  = (st == ST_CMD)  && (bytes_rem != 0) && (!spi_busy) && (buf_free >= need_bytes_cmd);
    wire can_start_data = (st == ST_DATA) && (bytes_rem != 0) && (!spi_busy) && (buf_free >= need_bytes_data);

    // pack a popped byte into BRAM word (little-endian)
    task automatic pack_and_maybe_write;
        input [7:0] b;
        reg [31:0] next_word;
        begin
            next_word = pack_word | ( {24'd0, b} << (8*pack_cnt) );

            if (pack_cnt == 2'd3) begin
                // complete 32-bit word -> write BRAM
                bram_en   <= 1'b1;
                bram_we   <= 4'hF;
                bram_din  <= next_word;
                bram_addr <= bram_addr + 1'b1;

                pack_cnt  <= 2'd0;
                pack_word <= 32'd0;
            end else begin
                pack_cnt  <= pack_cnt + 1'b1;
                pack_word <= next_word;
            end
        end
    endtask

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            st          <= ST_IDLE;
            busy        <= 1'b0;
            frame_done  <= 1'b0;

            spi_start   <= 1'b0;
            spi_hold_cs <= 1'b0;
            spi_tx16    <= 16'h0000;

            byte_valid  <= 1'b0;
            byte_data   <= 8'h00;

            buf0        <= 8'h00;
            buf1        <= 8'h00;
            buf_cnt     <= 2'd0;
            bytes_rem   <= 14'd0;

            bram_addr   <= 12'd0;
            bram_en     <= 1'b0;
            bram_we     <= 4'h0;
            bram_din    <= 32'd0;

            pack_cnt    <= 2'd0;
            pack_word   <= 32'd0;

        end else begin
            // defaults
            spi_start  <= 1'b0;
            frame_done <= 1'b0;
            byte_valid <= 1'b0;

            bram_en    <= 1'b0;
            bram_we    <= 4'h0;

            // ====================================================
            // 1) POP: if buffer has data, output 1 byte per clk
            //    AND pack to BRAM
            // ====================================================
            if (buf_cnt != 0) begin
                byte_valid <= 1'b1;
                byte_data  <= buf0;

                // pack this byte into 32-bit word and maybe write
                pack_and_maybe_write(buf0);

                // shift buffer
                if (buf_cnt == 2'd1) begin
                    buf_cnt <= 2'd0;
                end else begin
                    // buf_cnt == 2
                    buf0    <= buf1;
                    buf_cnt <= 2'd1;
                end
            end

            // ====================================================
            // 2) PUSH: on spi_done, push new bytes into buffer
            //    and decrement bytes_rem accordingly (single assignment)
            // ====================================================
            if (spi_done) begin
                if (st == ST_CMD) begin
                    if (bytes_rem != 0 && buf_cnt < 2) begin
                        // push 1 byte: rx16[7:0]
                        if (buf_cnt == 2'd0) begin
                            buf0    <= spi_rx16[7:0];
                            buf_cnt <= 2'd1;
                        end else begin
                            buf1    <= spi_rx16[7:0];
                            buf_cnt <= 2'd2;
                        end
                        bytes_rem <= bytes_rem - 14'd1;
                    end
                end else if (st == ST_DATA) begin
                    // can_start_data guarantees enough free space for need_bytes_data when launched
                    if (bytes_rem >= 14'd2) begin
                        // push two bytes: [15:8] then [7:0]
                        if (buf_cnt == 2'd0) begin
                            buf0    <= spi_rx16[15:8];
                            buf1    <= spi_rx16[7:0];
                            buf_cnt <= 2'd2;
                        end else if (buf_cnt == 2'd1) begin
                            buf1    <= spi_rx16[15:8];
                            buf_cnt <= 2'd2;
                            // second byte must wait (no room). BUT this case should not happen
                            // because can_start_data requires buf_free>=2 when bytes_rem>=2.
                        end
                        bytes_rem <= bytes_rem - 14'd2;
                    end else if (bytes_rem == 14'd1) begin
                        // push one byte: [15:8]
                        if (buf_cnt == 2'd0) begin
                            buf0    <= spi_rx16[15:8];
                            buf_cnt <= 2'd1;
                        end else begin
                            buf1    <= spi_rx16[15:8];
                            buf_cnt <= 2'd2;
                        end
                        bytes_rem <= bytes_rem - 14'd1;
                    end
                end
            end

            // ====================================================
            // 3) FSM control
            // ====================================================
            case (st)
                ST_IDLE: begin
                    busy        <= 1'b0;
                    spi_hold_cs <= 1'b0;

                    if (start_frame) begin
                        busy        <= 1'b1;
                        spi_hold_cs <= 1'b1;              // hold CS for whole burst
                        bytes_rem   <= BYTE_COUNT[13:0];
                        buf_cnt     <= 2'd0;

                        // reset BRAM write context per frame
                        bram_addr   <= 12'd0;
                        pack_cnt    <= 2'd0;
                        pack_word   <= 32'd0;

                        st <= ST_CMD;
                    end
                end

                ST_CMD: begin
                    if (can_start_cmd) begin
                        spi_tx16  <= {CMD_BYTE, 8'h00};
                        spi_start <= 1'b1;
                        st        <= ST_DATA;
                    end
                end

                ST_DATA: begin
                    if (can_start_data) begin
                        spi_tx16  <= 16'h0000;
                        spi_start <= 1'b1;
                    end

                    // finish when nothing left to receive, buffer empty, and SPI idle
                    if ((bytes_rem == 0) && (buf_cnt == 0) && (!spi_busy)) begin
                        st <= ST_END;
                    end
                end

                ST_END: begin
                    spi_hold_cs <= 1'b0;
                    busy        <= 1'b0;
                    frame_done  <= 1'b1;
                    st          <= ST_IDLE;
                end

                default: st <= ST_IDLE;
            endcase
        end
    end

endmodule
