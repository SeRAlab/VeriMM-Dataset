module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C // Changed C to be an output instead of a wire inside the module
);assign {C, S} = A + B; // Use concatenation to include the carry out from addition

endmodule