module serializer (
    input clk,
    input reset,
    input [15:0] data_in,
    input start,
    output reg serial_out,
    output reg done
);
    reg [3:0] bit_count; // To count the number of bits serialized
    reg [15:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            serial_out <= 0;
            done <= 0;
            shift_reg <= 0;
        end else if (start) begin
            shift_reg <= data_in; // Load data into the shift register
            bit_count <= 15; // Start from the highest bit
            done <= 0; // Reset done flag
        end else if (bit_count > 0) begin
            serial_out <= shift_reg[bit_count]; // Output the current bit
            bit_count <= bit_count - 1; // Move to the next bit
        end else if (bit_count == 0) begin
            done <= 1; // Signal that serialization is complete
        end
    end
endmodule