module hamming_encoder (
    input [7:0] data,
    output reg [11:0] codeword
);
    always @(*) begin
        codeword[2:0] = data[2:0]; // Data bits
        codeword[3] = data[3]; // Data bit
        codeword[4] = data[4]; // Data bit
        codeword[5] = data[5]; // Data bit
        codeword[6] = data[6]; // Data bit
        codeword[7] = data[7]; // Data bit

        // Calculate parity bits
        codeword[0] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[5]; // P1
        codeword[1] = data[0] ^ data[2] ^ data[3] ^ data[6] ^ data[7]; // P2
        codeword[8] = data[1] ^ data[2] ^ data[3] ^ data[6] ^ data[7]; // P4
        codeword[9] = data[4] ^ data[5] ^ data[6] ^ data[7]; // P8
        codeword[10] = 0; // Reserved for further use
        codeword[11] = 0; // Reserved for further use
    end
endmodule