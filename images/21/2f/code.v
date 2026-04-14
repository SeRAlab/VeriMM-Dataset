module md5_hash (
    input  [3:0] data_in,
    output [3:0] hash_out
);
    assign hash_out = {data_in[0] ^ data_in[1], data_in[1] ^ data_in[2], data_in[2] ^ data_in[3], data_in[3] ^ data_in[0]};
endmodule