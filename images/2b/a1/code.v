module hamming_encoder (
    input [15:0] data_in,
    output [20:0] code_out
);
    wire [4:0] p; // Parity bits
    wire [20:0] encoded;

    // Calculate parity bits
    assign p[0] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14];
    assign p[1] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10] ^ data_in[13] ^ data_in[14];
    assign p[2] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[15];
    assign p[3] = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15];
    assign p[4] = data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15];

    // Construct encoded output
    assign encoded[20] = p[4];
    assign encoded[19] = p[3];
    assign encoded[18] = data_in[15];
    assign encoded[17] = p[2];
    assign encoded[16] = data_in[14];
    assign encoded[15] = data_in[13];
    assign encoded[14] = data_in[12];
    assign encoded[13] = p[1];
    assign encoded[12] = data_in[11];
    assign encoded[11] = data_in[10];
    assign encoded[10] = data_in[9];
    assign encoded[9] = data_in[8];
    assign encoded[8] = data_in[7];
    assign encoded[7] = data_in[6];
    assign encoded[6] = data_in[5];
    assign encoded[5] = data_in[4];
    assign encoded[4] = p[0];
    assign encoded[3] = data_in[3];
    assign encoded[2] = data_in[2];
    assign encoded[1] = data_in[1];
    assign encoded[0] = data_in[0];

    assign code_out = encoded;

endmodule