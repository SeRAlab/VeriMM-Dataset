module binary_to_gray(
    input  [2:0] bin_in,

    output [2:0] gray_out
);

assign gray_out = bin_in ^ (bin_in >> 1);

endmodule