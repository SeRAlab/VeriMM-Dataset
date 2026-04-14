module hamming_encoder (
    input [3:0] data,
    output reg [6:0] codeword
);
    always @(*) begin
        // Assign data bits
        codeword[2:0] = data[2:0]; // d0, d1, d2

        // Calculate parity bits
        codeword[3] = data[0] ^ data[1] ^ data[2]; // p1
        codeword[4] = data[0] ^ data[1] ^ codeword[2]; // p2
        codeword[5] = data[1] ^ data[2] ^ codeword[3]; // p3

        // Assign the last bit to the original data
        codeword[6] = data[3]; // d3
    end
endmodule