module spi_master (
    input wire clk,          // system clock
    input wire reset_n,      // active low reset
    input wire start,        // start transmission
    input wire [7:0] data_in, // input data to send
    output reg miso,         // master out slave in
    output reg mosi,         // master in slave out
    output reg sclk,         // SPI clock
    output reg done          // transmission done
);

reg [2:0] state;
reg [2:0] bit_cnt;
reg [7:0] shift_reg;

localparam IDLE = 3'b000,
           SETUP = 3'b001,
           TRANSFER = 3'b010,
           DONE = 3'b011;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
        mosi <= 1'b0;
        sclk <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                done <= 1'b0;
                if (start) begin
                    shift_reg <= data_in;
                    bit_cnt <= 3'b000;
                    state <= SETUP;
                end
            end
            SETUP: begin
                sclk <= 1'b0;
                state <= TRANSFER;
            end
            TRANSFER: begin
                if (bit_cnt < 8) begin
                    sclk <= ~sclk; // toggle clock
                    if (sclk) begin
                        mosi <= shift_reg[7]; // send MSB first
                        shift_reg <= {shift_reg[6:0], 1'b0}; // shift left
                        bit_cnt <= bit_cnt + 1;
                    end
                end else begin
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1'b1;
                state <= IDLE;
            end
        endcase
    end
end

endmodule