module sample_rate_converter (
    input [3:0] data_in,
    output [1:0] data_out
);
    assign data_out = data_in[3:2];
endmodule