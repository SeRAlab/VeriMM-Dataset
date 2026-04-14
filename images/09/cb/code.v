module hamming_encoder (
    input [3:0] data,
    output [6:0] encoded
);
    // Parity bits
    wire p1, p2, p3;

    // Calculate parity bits
    assign p1 = data[0] ^ data[1] ^ data[3]; // parity for bits 1, 2, and 4
    assign p2 = data[0] ^ data[2] ^ data[3]; // parity for bits 1, 3, and 4
    assign p3 = data[1] ^ data[2] ^ data[3]; // parity for bits 2, 3, and 4

    // Assign encoded output
    assign encoded[6] = p3; // bit 7 (p3)
    assign encoded[5] = p2; // bit 6 (p2)
    assign encoded[4] = data[3]; // bit 5 (d4)
    assign encoded[3] = p1; // bit 4 (p1)
    assign encoded[2] = data[2]; // bit 3 (d3)
    assign encoded[1] = data[1]; // bit 2 (d2)
    assign encoded[0] = data[0]; // bit 1 (d1)
endmodule