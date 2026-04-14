module binary_subtractor (
    input [2:0] a,
    input [2:0] b,
    output [2:0] diff
);

    assign diff = a - b;

endmodule