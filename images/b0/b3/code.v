module top_module(
    input [2:0] binary_in,
    output [2:0] gray_out
);assign gray_out[0] = binary_in[0];
    assign gray_out[1] = binary_in[0] ^ binary_in[1];
    assign gray_out[2] = binary_in[1] ^ binary_in[2];

endmodule