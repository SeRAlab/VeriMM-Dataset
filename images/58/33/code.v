module binary_to_gray (
    input [1:0] binary,
    output [1:0] gray
);

    assign gray = {binary[1], binary[1] ^ binary[0]};

endmodule