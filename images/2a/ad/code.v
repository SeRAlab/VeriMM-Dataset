module hamming_encoder (
    input [3:0] data,        // 4-bit data input
    output [6:0] encoded     // 7-bit encoded output
);
    assign encoded[6] = data[0] ^ data[1] ^ data[3]; // P1
    assign encoded[5] = data[0] ^ data[2] ^ data[3]; // P2
    assign encoded[4] = data[1] ^ data[2] ^ data[3]; // P3
    assign encoded[3] = data[0];                       // D1
    assign encoded[2] = data[1];                       // D2
    assign encoded[1] = data[2];                       // D3
    assign encoded[0] = data[3];                       // D4
endmodule