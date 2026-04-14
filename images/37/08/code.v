module deserializer (
    input wire clk,
    input wire serial_in,
    output reg [7:0] parallel_out,
    output reg data_valid
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (bit_count < 8) begin
            shift_reg <= {shift_reg[6:0], serial_in}; // Shift in the new bit
            bit_count <= bit_count + 1;
            data_valid <= 0; // Data not valid until 8 bits are received
        end
        if (bit_count == 7) begin
            data_valid <= 1; // Data is valid when 8 bits are received
            parallel_out <= shift_reg; // Output the 8 bits
        end
        if (bit_count == 8) begin
            bit_count <= 0; // Reset the bit count for the next byte
            shift_reg <= 0; // Clear the shift register
            data_valid <= 0; // Data invalid until next 8 bits
        end
    end
endmodule