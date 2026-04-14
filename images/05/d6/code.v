module hamming_encoder (
    input [3:0] data_in,
    output reg [6:0] codeword_out
);
    always @(*) begin
        // Assign data bits
        codeword_out[2:0] = data_in[2:0];
        codeword_out[4:3] = data_in[3];

        // Calculate parity bits
        codeword_out[6] = data_in[0] ^ data_in[1] ^ data_in[3]; // P1
        codeword_out[5] = data_in[0] ^ data_in[2] ^ data_in[3]; // P2
        codeword_out[1] = data_in[1] ^ data_in[2] ^ data_in[3]; // P3
        codeword_out[0] = 0; // Not used in Hamming (7,4)
    end
endmodule