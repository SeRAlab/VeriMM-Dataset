module subtractor_2bit(
    input [1:0] a,
    input [1:0] b,
    output [1:0] diff
);

    assign diff = a - b;

endmodule