module hamming_encoder (
    input [3:0] data, // 4 input bits
    output reg [6:0] code // 7 output bits
);
    always @(*) begin
        // Assign data bits
        code[2] = data[3]; // D3
        code[3] = data[2]; // D2
        code[4] = data[1]; // D1
        code[5] = data[0]; // D0
        
        // Calculate parity bits
        code[0] = data[3] ^ data[2] ^ data[0]; // P6
        code[1] = data[3] ^ data[1] ^ data[0]; // P5
        code[6] = data[2] ^ data[1] ^ data[0]; // P4
    end
endmodule