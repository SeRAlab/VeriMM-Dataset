module spi_controller(
    input wire clk,
    input wire serial_in,
    output reg [7:0] data_out
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (bit_count < 8) begin
            shift_reg <= {shift_reg[6:0], serial_in}; // Shift in serial data
            bit_count <= bit_count + 1; // Increment bit count
        end
        else begin
            data_out <= shift_reg; // Latch the output after 8 bits
            bit_count <= 0; // Reset bit count
            shift_reg <= 0; // Clear shift register
        end
    end
endmodule