module hamming_encoder(
    input [3:0] data,
    output [6:0] codeword
);
    assign codeword[0] = data[0];
    assign codeword[1] = data[1];
    assign codeword[2] = data[2];
    assign codeword[3] = data[3];

    assign codeword[4] = data[0] ^ data[1] ^ data[3]; // P1
    assign codeword[5] = data[0] ^ data[2] ^ data[3]; // P2
    assign codeword[6] = data[1] ^ data[2] ^ data[3]; // P3
endmodule