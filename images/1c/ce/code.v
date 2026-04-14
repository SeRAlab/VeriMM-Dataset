module serializer (
    input wire clk,
    input wire start,
    input wire [7:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [2:0] bit_counter;  // to count the number of bits serialized
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (start) begin
            shift_reg <= parallel_in; // Load the input to shift register
            bit_counter <= 3'b111; // Start with 8 bits (counting down)
            done <= 0; // Reset done flag
        end else if (bit_counter != 3'b000) begin
            serial_out <= shift_reg[7]; // Output the MSB
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            bit_counter <= bit_counter - 1; // Decrement bit counter
        end else begin
            done <= 1; // Indicate serialization is done
        end
    end
endmodule