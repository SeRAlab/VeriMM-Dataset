module fixed_point_multiplier (
    input signed [15:0] a,
    input signed [15:0] b,
    output signed [31:0] product
);
    assign product = a * b;  // Multiplying the two fixed-point numbers
endmodule