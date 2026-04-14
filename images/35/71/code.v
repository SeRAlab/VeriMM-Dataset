module hamming_encoder (
    input [3:0] data, // 4-bit data input
    output reg [6:0] encoded // 7-bit encoded output
);
    always @* begin
        // Calculate parity bits
        encoded[0] = data[0]; // d1
        encoded[1] = data[1]; // d2
        encoded[2] = data[2]; // d3
        encoded[3] = data[3]; // d4
        encoded[4] = data[0] ^ data[1] ^ data[3]; // p1
        encoded[5] = data[0] ^ data[2] ^ data[3]; // p2
        encoded[6] = data[1] ^ data[2] ^ data[3]; // p3
    end
endmodule