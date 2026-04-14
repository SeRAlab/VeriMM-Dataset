module sign_extension(
    input signed [15:0] data_in,
    output signed [15:0] data_out
);

assign data_out = (data_in < 0) ? {16'b1, data_in[15:0]} : {16'b0, data_in[15:0]};

endmodule