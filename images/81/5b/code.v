module binary_decoder(
    input  [1:0] bin_in,

    output [3:0] one_hot_out
);

assign one_hot_out = 1 << bin_in;

endmodule