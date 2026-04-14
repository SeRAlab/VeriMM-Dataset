module hamming_encoder (
    input [15:0] data_in,
    output [20:0] code_out
);
    wire [20:0] extended_data;
    wire [4:0] parity;

    // Extend data input to 21 bits
    assign extended_data = {data_in, 5'b0};

    // Calculate parity bits
    assign parity[0] = extended_data[0] ^ extended_data[1] ^ extended_data[3] ^ extended_data[4] ^ extended_data[6] ^ extended_data[8] ^ extended_data[10] ^ extended_data[12] ^ extended_data[14] ^ extended_data[16] ^ extended_data[18];
    assign parity[1] = extended_data[0] ^ extended_data[2] ^ extended_data[3] ^ extended_data[5] ^ extended_data[6] ^ extended_data[9] ^ extended_data[10] ^ extended_data[13] ^ extended_data[14] ^ extended_data[17] ^ extended_data[19];
    assign parity[2] = extended_data[1] ^ extended_data[2] ^ extended_data[3] ^ extended_data[7] ^ extended_data[8] ^ extended_data[9] ^ extended_data[10] ^ extended_data[15] ^ extended_data[16] ^ extended_data[19];
    assign parity[3] = extended_data[4] ^ extended_data[5] ^ extended_data[6] ^ extended_data[7] ^ extended_data[8] ^ extended_data[9] ^ extended_data[10] ^ extended_data[11] ^ extended_data[12] ^ extended_data[13] ^ extended_data[14] ^ extended_data[15];
    assign parity[4] = extended_data[0] ^ extended_data[1] ^ extended_data[2] ^ extended_data[4] ^ extended_data[5] ^ extended_data[6] ^ extended_data[8] ^ extended_data[9] ^ extended_data[10] ^ extended_data[12] ^ extended_data[13] ^ extended_data[14];

    // Combine data and parity
    assign code_out = {parity, extended_data[15:0]};
endmodule