module top_module(
    input a,
    input b,
    output out
);wire inv_a, inv_b, diff;

// Obtain the inverse of both inputs
nand (inv_a, a, a);
nand (inv_b, b, b);

// Obtain the difference between the inputs
xor (diff, a, b);

// Combine the difference and the inverse of the inputs to generate the output
nand (out, diff, inv_a, inv_b);

endmodule