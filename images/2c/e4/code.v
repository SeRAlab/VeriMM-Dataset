module hamming_encoder (
    input [3:0] data,
    output reg [6:0] codeword
);
    always @(*) begin
        // Assign data bits
        codeword[2:0] = data; // Data bits d1, d2, d3, d4 are data[3:0]
        
        // Calculate parity bits
        codeword[3] = data[0] ^ data[1] ^ data[3]; // p1
        codeword[4] = data[0] ^ data[2] ^ data[3]; // p2
        codeword[5] = data[1] ^ data[2] ^ data[3]; // p3
        codeword[6] = 0; // This bit is not used in (7,4) Hamming code
    end
endmodule