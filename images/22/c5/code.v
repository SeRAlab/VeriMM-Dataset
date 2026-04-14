module hamming_encoder (
    input [3:0] data,
    output [6:0] code
);
    assign code[0] = data[0]; // d1
    assign code[1] = data[1]; // d2
    assign code[2] = data[2]; // d3
    assign code[3] = data[3]; // d4
    assign code[4] = data[0] ^ data[1] ^ data[3]; // p1
    assign code[5] = data[0] ^ data[2] ^ data[3]; // p2
    assign code[6] = data[1] ^ data[2] ^ data[3]; // p3
endmodule