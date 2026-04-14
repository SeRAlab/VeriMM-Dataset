module checksum(
    input [4:0] data_in,
    output checksum_out
);
    assign checksum_out = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4];
endmodule