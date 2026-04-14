module binary_to_gray_4bit (
    input [3:0] bin_in,
    output [3:0] gray_out
);

assign gray_out = bin_in ^ (bin_in >> 1);

endmodule