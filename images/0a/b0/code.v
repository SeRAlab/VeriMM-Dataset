module spi_master (
    input clk,
    input reset,
    input mosi,
    output reg miso,
    input ss,
    input start,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg busy
);
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            busy <= 0;
            bit_cnt <= 0;
            miso <= 0;
            data_out <= 0;
        end else if (start && !busy) begin
            busy <= 1;
            bit_cnt <= 0;
            shift_reg <= data_in;
        end else if (busy) begin
            miso <= shift_reg[7]; // Send the MSB first
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift to send the next bit
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == 7) begin
                busy <= 0; // Transaction complete
                data_out <= {miso, shift_reg[6:0]}; // Capture the received data
            end
        end
    end
endmodule