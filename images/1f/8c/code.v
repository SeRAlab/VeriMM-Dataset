module hamming_encoder (
    input [3:0] D,
    output reg [6:0] Y
);
    always @(*) begin
        // Assigning parity bits according to Hamming (7,4) encoding
        Y[0] = D[0];  // Data bit
        Y[1] = D[1];  // Data bit
        Y[2] = D[2];  // Data bit
        Y[3] = D[3];  // Data bit
        
        // Calculate parity bits
        Y[4] = D[0] ^ D[1] ^ D[3]; // P1
        Y[5] = D[0] ^ D[2] ^ D[3]; // P2
        Y[6] = D[1] ^ D[2] ^ D[3]; // P3
    end
endmodule