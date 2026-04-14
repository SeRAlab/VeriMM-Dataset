module hamming_encoder (
    input [15:0] data_in,
    output [19:0] codeword_out
);
    wire [3:0] parity;
    
    assign codeword_out[0] = data_in[0];
    assign codeword_out[1] = data_in[1];
    assign codeword_out[2] = data_in[2];
    assign codeword_out[3] = data_in[3];
    assign codeword_out[4] = data_in[4];
    assign codeword_out[5] = data_in[5];
    assign codeword_out[6] = data_in[6];
    assign codeword_out[7] = data_in[7];
    assign codeword_out[8] = data_in[8];
    assign codeword_out[9] = data_in[9];
    assign codeword_out[10] = data_in[10];
    assign codeword_out[11] = data_in[11];
    assign codeword_out[12] = data_in[12];
    assign codeword_out[13] = data_in[13];
    assign codeword_out[14] = data_in[14];
    assign codeword_out[15] = data_in[15];
    
    // Parity bits calculations
    assign parity[0] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[9] ^ data_in[11] ^ data_in[12];
    assign parity[1] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[13];
    assign parity[2] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[14];
    assign parity[3] = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[15];

    assign codeword_out[16] = parity[0];
    assign codeword_out[17] = parity[1];
    assign codeword_out[18] = parity[2];
    assign codeword_out[19] = parity[3];

endmodule