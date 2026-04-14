module binary_to_gray (
    input [7:0] bin,
    output [7:0] gray
);

    assign gray = (bin >> 1) ^ bin;

endmodule