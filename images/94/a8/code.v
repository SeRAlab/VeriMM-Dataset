module binary_to_gray (
    input [1:0] bin,
    output [1:0] gray
);

    assign gray[1] = bin[1];
    assign gray[0] = bin[1] ^ bin[0];

endmodule