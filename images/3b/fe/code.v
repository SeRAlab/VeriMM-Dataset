module hamming_encoder (
    input [3:0] data,
    output [6:0] encoded
);
    assign encoded[0] = data[0]; // d1
    assign encoded[1] = data[1]; // d2
    assign encoded[2] = data[2]; // d3
    assign encoded[3] = data[3]; // d4
    assign encoded[4] = data[0] ^ data[1] ^ data[3]; // p1
    assign encoded[5] = data[0] ^ data[2] ^ data[3]; // p2
    assign encoded[6] = data[1] ^ data[2] ^ data[3]; // p3
endmodule