module spi_controller(
    input clk,
    input start,
    input [7:0] data_in,
    output reg mosi
);
    reg [2:0] bit_count; // 3-bit counter for 8 bits
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (start) begin
            shift_reg <= data_in; // Load data into shift register
            bit_count <= 3'b000; // Reset bit count
        end else if (bit_count < 3'b111) begin
            mosi <= shift_reg[7]; // Shift out the MSB
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            bit_count <= bit_count + 1; // Increment bit count
        end else begin
            mosi <= 0; // After transmission, set mosi to 0
        end
    end
endmodule