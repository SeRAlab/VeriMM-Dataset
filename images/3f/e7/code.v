module hamming_encoder (
    input [3:0] data,
    output reg [6:0] encoded
);
    always @(*) begin
        // Assign data bits
        encoded[2:0] = data[2:0]; // d0, d1, d2

        // Compute parity bits
        encoded[3] = data[0] ^ data[1] ^ data[2]; // p1
        encoded[4] = data[0] ^ data[1] ^ data[3]; // p2
        encoded[5] = data[1] ^ data[2] ^ data[3]; // p3

        // Assign the last bit (not used in (7,4))
        encoded[6] = 0; // Not used in Hamming (7,4)
    end
endmodule