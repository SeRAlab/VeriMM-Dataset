module hamming_encoder (
    input [15:0] data,
    output [20:0] encoded
);
    wire [20:0] p; // Parity bits
    wire [15:0] d; // Data bits

    assign d = data;
    
    // Assign data bits to encoded positions
    assign encoded[0] = d[0];
    assign encoded[1] = d[1];
    assign encoded[2] = d[2];
    assign encoded[3] = d[3];
    assign encoded[4] = d[4];
    assign encoded[5] = d[5];
    assign encoded[6] = d[6];
    assign encoded[7] = d[7];
    assign encoded[8] = d[8];
    assign encoded[9] = d[9];
    assign encoded[10] = d[10];
    assign encoded[11] = d[11];
    assign encoded[12] = d[12];
    assign encoded[13] = d[13];
    assign encoded[14] = d[14];
    assign encoded[15] = d[15];

    // Parity calculations
    assign encoded[16] = d[0] ^ d[1] ^ d[3] ^ d[4] ^ d[5] ^ d[7] ^ d[8] ^ d[9] ^ d[10] ^ d[12] ^ d[13] ^ d[14]; // P1
    assign encoded[17] = d[0] ^ d[2] ^ d[3] ^ d[4] ^ d[6] ^ d[7] ^ d[8] ^ d[10] ^ d[11] ^ d[12] ^ d[13]; // P2
    assign encoded[18] = d[1] ^ d[2] ^ d[3] ^ d[5] ^ d[6] ^ d[7] ^ d[9] ^ d[10] ^ d[11] ^ d[12]; // P4
    assign encoded[19] = d[8] ^ d[9] ^ d[10] ^ d[11] ^ d[12] ^ d[13]; // P8
    assign encoded[20] = d[16]; // P16 (not used in 16-bit data)

endmodule