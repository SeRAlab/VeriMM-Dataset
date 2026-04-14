module fixed_point_multiplier (
    input [15:0] a, // First input in Q1.15 format
    input [15:0] b, // Second input in Q1.15 format
    output reg [31:0] product // Output in Q1.31 format
);
    always @(*) begin
        product = a * b; // Multiply the two inputs
    end
endmodule