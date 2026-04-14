module bin_to_gray_10bit(
    input [9:0] bin_in,
    output [9:0] gray_out
);

assign gray_out = (bin_in >> 1) ^ bin_in;

endmodule