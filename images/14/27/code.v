module hamming_encoder(
    input [15:0] data_in,
    output [19:0] code_out
);
    wire [19:0] extended_data;
    assign extended_data = {data_in, 4'b0000}; // Extend data to 20 bits

    // Parity bits calculation
    assign code_out[0] = extended_data[0] ^ extended_data[1] ^ extended_data[3] ^ extended_data[4] ^ extended_data[6] ^ extended_data[8] ^ extended_data[10] ^ extended_data[12] ^ extended_data[14] ^ extended_data[16] ^ extended_data[18];
    assign code_out[1] = extended_data[0] ^ extended_data[2] ^ extended_data[3] ^ extended_data[5] ^ extended_data[6] ^ extended_data[8] ^ extended_data[10] ^ extended_data[12] ^ extended_data[14] ^ extended_data[17] ^ extended_data[18];
    assign code_out[2] = extended_data[1] ^ extended_data[2] ^ extended_data[3] ^ extended_data[7] ^ extended_data[8] ^ extended_data[9] ^ extended_data[10] ^ extended_data[13] ^ extended_data[14] ^ extended_data[17];
    assign code_out[3] = extended_data[4] ^ extended_data[5] ^ extended_data[6] ^ extended_data[7] ^ extended_data[8] ^ extended_data[9] ^ extended_data[10] ^ extended_data[11] ^ extended_data[12] ^ extended_data[13];

    // Combine data and parity bits
    assign code_out[19:4] = extended_data[15:0];

endmodule