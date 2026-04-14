module fixed_point_multiplier (
    input [15:0] a,  // Fixed-point input a
    input [15:0] b,  // Fixed-point input b
    output [31:0] product  // Fixed-point output product
);
    assign product = a * b;  // Multiply the two fixed-point inputs
endmodule