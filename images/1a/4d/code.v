module hamming_encoder (
    input [3:0] data,
    output reg [6:0] code
);
    always @(*) begin
        // Assign data bits
        code[2:0] = data[2:0]; // d0, d1, d2
        code[4] = data[3];      // d3

        // Calculate parity bits
        code[5] = data[0] ^ data[1] ^ data[3]; // p1
        code[6] = data[0] ^ data[2] ^ data[3]; // p2
        code[3] = data[1] ^ data[2] ^ data[3]; // p3
    end
endmodule