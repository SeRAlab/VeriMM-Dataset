module hamming_encoder (
    input [7:0] data,
    output reg [11:0] code
);
    always @(*) begin
        // Calculate parity bits
        code[2] = data[0] ^ data[1] ^ data[3]; // p1
        code[4] = data[0] ^ data[2] ^ data[3]; // p2
        code[5] = data[1] ^ data[2] ^ data[3]; // p3
        code[6] = data[4] ^ data[5] ^ data[7]; // p4
        code[8] = data[0] ^ data[1] ^ data[2] ^ data[4] ^ data[5] ^ data[6]; // p5
        code[9] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6]; // p6
        code[10] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6]; // p7
        code[11] = data[7]; // data bit
        
        // Fill in data bits
        code[0] = data[0];
        code[1] = data[1];
        code[3] = data[2];
        code[7] = data[3];
        code[12] = data[4];
        code[13] = data[5];
        code[14] = data[6];
        code[15] = data[7];
    end
endmodule