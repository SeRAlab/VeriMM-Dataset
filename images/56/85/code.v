module subtractor_4bit (
    input [3:0] a,
    input [3:0] b,
    output [3:0] diff
);

    // Subtractor logic
    assign diff = a - b;

endmodule