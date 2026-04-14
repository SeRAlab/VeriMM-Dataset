module rs_encoder (
    input [3:0] data_in,
    output [6:0] encoded_out
);
    assign encoded_out = {data_in, (data_in[3] ^ data_in[2]), (data_in[3] ^ data_in[1]), (data_in[2] ^ data_in[1]), (data_in[3] ^ data_in[0]), (data_in[2] ^ data_in[0]), (data_in[1] ^ data_in[0])};
endmodule