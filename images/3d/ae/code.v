module hamming_encoder (
    input [3:0] d,
    output reg [6:0] codeword
);
    always @(*) begin
        // Compute parity bits
        codeword[0] = d[0]; // Data bit 0
        codeword[1] = d[1]; // Data bit 1
        codeword[2] = d[2]; // Data bit 2
        codeword[3] = d[3]; // Data bit 3

        // Calculate parity bits
        codeword[4] = d[0] ^ d[1] ^ d[3]; // p1
        codeword[5] = d[0] ^ d[2] ^ d[3]; // p2
        codeword[6] = d[1] ^ d[2] ^ d[3]; // p3
    end
endmodule