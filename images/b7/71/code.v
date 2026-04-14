module bin_to_onehot(
    input [1:0] bin,

    output [3:0] dec_out
);

assign dec_out = 4'b0001 << bin;

endmodule