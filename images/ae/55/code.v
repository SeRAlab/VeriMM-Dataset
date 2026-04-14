module top_module(
    input [3:0] a,
    input [3:0] b,
    output [4:0] diff
);

    // Subtract the inputs
    assign diff = a - b;

endmodule