module fixed_point_multiplier (
    input [7:0] a,
    input [7:0] b,
    output [15:0] product
);
    // Fixed-point multiplication
    assign product = a * b; // 8-bit * 8-bit = 16-bit result
endmodule