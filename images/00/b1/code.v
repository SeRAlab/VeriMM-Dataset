module serializer(
    input clk,
    input reset,
    input start,
    input [7:0] data_in,
    output reg serial_out,
    output reg done
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 3'b000;
            shift_reg <= 8'b0;
            serial_out <= 0;
            done <= 0;
        end else if (start && bit_count == 3'b000) begin
            shift_reg <= data_in;
            bit_count <= 3'b111;  // Load the full 8 bits
            done <= 0;
        end else if (bit_count > 0) begin
            serial_out <= shift_reg[7]; // Output the MSB
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            bit_count <= bit_count - 1; // Decrement bit count
            if (bit_count == 1) begin
                done <= 1;  // Indicate serialization is done
            end
        end
    end
endmodule