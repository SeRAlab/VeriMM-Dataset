module hamming_encoder (
    input [15:0] data,
    output [19:0] encoded
);
    wire [3:0] p; // parity bits

    // Calculate parity bits
    assign p[0] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6] ^ data[8] ^ data[9] ^ data[11] ^ data[12] ^ data[14];
    assign p[1] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[8] ^ data[10] ^ data[11] ^ data[13] ^ data[14];
    assign p[2] = data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[9] ^ data[10] ^ data[11] ^ data[13] ^ data[15];
    assign p[3] = data[4] ^ data[5] ^ data[6] ^ data[7] ^ data[8] ^ data[9] ^ data[10] ^ data[12] ^ data[13] ^ data[15];

    // Assign encoded output
    assign encoded = {p, data};

endmodule