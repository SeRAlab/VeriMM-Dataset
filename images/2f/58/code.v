module hamming_encoder(
    input [7:0] data,
    output reg [11:0] code
);
    always @(*) begin
        // Initialize code with data bits and parity bits
        code = 12'b0;
        code[2] = data[0]; // d1
        code[4] = data[1]; // d2
        code[5] = data[2]; // d3
        code[6] = data[3]; // d4
        code[8] = data[4]; // d5
        code[9] = data[5]; // d6
        code[10] = data[6]; // d7
        code[11] = data[7]; // d8

        // Calculate parity bits
        code[0] = code[2] ^ code[4] ^ code[6] ^ code[8]; // p1
        code[1] = code[2] ^ code[5] ^ code[6] ^ code[9]; // p2
        code[3] = code[4] ^ code[5] ^ code[6] ^ code[10]; // p4
        code[7] = code[8] ^ code[9] ^ code[10] ^ code[11]; // p8
    end
endmodule