module fixed_point_multiplier (
    input signed [7:0] a,  // 8-bit signed fixed-point input
    input signed [7:0] b,  // 8-bit signed fixed-point input
    output signed [15:0] result  // 16-bit signed fixed-point output
);
    assign result = a * b; // Perform multiplication
endmodule