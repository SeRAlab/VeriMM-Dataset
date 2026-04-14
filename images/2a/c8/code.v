module hamming_encoder (
    input [3:0] data,
    output [6:0] code
);
    assign code[6] = data[0] ^ data[1] ^ data[3];
    assign code[5] = data[0] ^ data[2] ^ data[3];
    assign code[4] = data[1] ^ data[2] ^ data[3];
    assign code[3] = data[0];
    assign code[2] = data[1];
    assign code[1] = data[2];
    assign code[0] = data[3];
endmodule