module hamming_encoder(
    input [15:0] data,
    output reg [19:0] encoded
);
    always @(*) begin
        // Initialize output
        encoded = 20'b0;
        
        // Assign data bits to encoded bits
        encoded[0] = data[0];
        encoded[1] = data[1];
        encoded[2] = data[2];
        encoded[3] = data[3];
        encoded[4] = data[4];
        encoded[5] = data[5];
        encoded[6] = data[6];
        encoded[7] = data[7];
        encoded[8] = data[8];
        encoded[9] = data[9];
        encoded[10] = data[10];
        encoded[11] = data[11];
        encoded[12] = data[12];
        encoded[13] = data[13];
        encoded[14] = data[14];
        encoded[15] = data[15];
        
        // Calculate parity bits
        encoded[16] = data[0] ^ data[1] ^ data[3] ^ data[4] ^ data[6] ^ data[8] ^ data[10] ^ data[12] ^ data[14]; // P1
        encoded[17] = data[0] ^ data[2] ^ data[3] ^ data[5] ^ data[6] ^ data[8] ^ data[10] ^ data[13] ^ data[15]; // P2
        encoded[18] = data[1] ^ data[2] ^ data[3] ^ data[5] ^ data[7] ^ data[8] ^ data[9] ^ data[11] ^ data[13]; // P4
        encoded[19] = data[0] ^ data[1] ^ data[2] ^ data[4] ^ data[5] ^ data[7] ^ data[8] ^ data[12] ^ data[13]; // P8
    end
endmodule