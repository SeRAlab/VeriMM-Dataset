module hamming_encoder(
    input [3:0] data,
    output [6:0] code
);
    // Assign data bits to code
    assign code[2:0] = data;  // D0, D1, D2, D3 are directly assigned
    
    // Calculate parity bits
    assign code[3] = data[0] ^ data[1] ^ data[3];  // P1
    assign code[4] = data[0] ^ data[2] ^ data[3];  // P2
    assign code[5] = data[1] ^ data[2] ^ data[3];  // P3
    
    assign code[6] = 1'b0; // Not used; can be set to any value or calculated as needed.
endmodule