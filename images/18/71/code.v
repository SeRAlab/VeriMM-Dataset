module hamming_encoder (
    input [3:0] data, // D3, D2, D1, D0
    output reg [6:0] code // C6, C5, C4, C3, C2, C1, C0
);

always @(*) begin
    // Assign data bits
    code[3] = data[3]; // D3
    code[5] = data[2]; // D2
    code[6] = data[1]; // D1
    code[4] = data[0]; // D0

    // Calculate parity bits
    code[0] = code[3] ^ code[5] ^ code[4]; // P1
    code[1] = code[3] ^ code[6] ^ code[4]; // P2
    code[2] = code[5] ^ code[6] ^ code[4]; // P3
end

endmodule