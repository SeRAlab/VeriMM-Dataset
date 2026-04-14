module hamming_encoder (
    input [15:0] data_in,
    output [20:0] codeword
);
    wire [10:0] parity_bits;
    wire [15:0] data_with_parity;

    assign data_with_parity = {data_in, 5'b0}; // Extend data for parity bits

    // Compute parity bits
    assign parity_bits[0] = data_with_parity[0] ^ data_with_parity[1] ^ data_with_parity[3] ^ data_with_parity[4] ^ data_with_parity[6] ^ data_with_parity[8] ^ data_with_parity[10] ^ data_with_parity[12] ^ data_with_parity[14] ^ data_with_parity[16] ^ data_with_parity[18] ^ data_with_parity[20];
    assign parity_bits[1] = data_with_parity[0] ^ data_with_parity[2] ^ data_with_parity[3] ^ data_with_parity[5] ^ data_with_parity[6] ^ data_with_parity[9] ^ data_with_parity[10] ^ data_with_parity[13] ^ data_with_parity[14] ^ data_with_parity[17] ^ data_with_parity[18] ^ data_with_parity[19];
    assign parity_bits[2] = data_with_parity[1] ^ data_with_parity[2] ^ data_with_parity[3] ^ data_with_parity[7] ^ data_with_parity[8] ^ data_with_parity[9] ^ data_with_parity[11] ^ data_with_parity[12] ^ data_with_parity[13] ^ data_with_parity[17] ^ data_with_parity[19] ^ data_with_parity[20];
    assign parity_bits[3] = data_with_parity[4] ^ data_with_parity[5] ^ data_with_parity[6] ^ data_with_parity[7] ^ data_with_parity[8] ^ data_with_parity[12] ^ data_with_parity[13] ^ data_with_parity[14] ^ data_with_parity[18] ^ data_with_parity[19] ^ data_with_parity[20];
    assign parity_bits[4] = data_with_parity[0] ^ data_with_parity[1] ^ data_with_parity[2] ^ data_with_parity[3] ^ data_with_parity[4] ^ data_with_parity[5] ^ data_with_parity[6] ^ data_with_parity[7] ^ data_with_parity[8] ^ data_with_parity[9] ^ data_with_parity[10] ^ data_with_parity[11] ^ data_with_parity[12] ^ data_with_parity[13] ^ data_with_parity[14] ^ data_with_parity[15] ^ data_with_parity[16] ^ data_with_parity[17] ^ data_with_parity[18] ^ data_with_parity[19] ^ data_with_parity[20];

    assign codeword = {parity_bits, data_in};

endmodule