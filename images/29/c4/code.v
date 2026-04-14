module serializer (
    input wire clk,
    input wire start,
    input wire enable,
    input wire [7:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [2:0] bit_count;  // 3-bit counter (0 to 7)
    reg [7:0] shift_reg;  // Holds the 8-bit input

    always @(posedge clk) begin
        if (start) begin
            bit_count <= 3'b000;
            shift_reg <= parallel_in;
            done <= 0;
        end else if (enable && bit_count < 3'b1000) begin
            serial_out <= shift_reg[7]; // Output the MSB first
            shift_reg <= {shift_reg[6:0], 1'b0}; // Shift left
            bit_count <= bit_count + 1;
        end else if (bit_count == 3'b1000) begin
            done <= 1; // Signal that serialization is done
        end
    end
endmodule