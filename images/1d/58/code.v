module hamming_encoder (
    input [7:0] data,
    output [11:0] hamming_code
);
    assign hamming_code[2:0] = {data[6] ^ data[5] ^ data[4], data[7] ^ data[5] ^ data[3], data[7] ^ data[6] ^ data[3]};
    assign hamming_code[11:3] = data;
endmodule