module hamming_encoder (
    input [15:0] data_in,
    output reg [20:0] code_out
);
    always @(*) begin
        // Compute parity bits for Hamming (21,16) encoding
        // Data bits are D1, D2, ..., D16
        // Parity bits are P1, P2, P4, P8, P16
        
        code_out[0] = data_in[0]; // D1
        code_out[1] = data_in[1]; // D2
        code_out[2] = data_in[2]; // D3
        code_out[3] = data_in[3]; // D4
        code_out[4] = data_in[4]; // D5
        code_out[5] = data_in[5]; // D6
        code_out[6] = data_in[6]; // D7
        code_out[7] = data_in[7]; // D8
        code_out[8] = data_in[8]; // D9
        code_out[9] = data_in[9]; // D10
        code_out[10] = data_in[10]; // D11
        code_out[11] = data_in[11]; // D12
        code_out[12] = data_in[12]; // D13
        code_out[13] = data_in[13]; // D14
        code_out[14] = data_in[14]; // D15
        code_out[15] = data_in[15]; // D16
        
        // Calculate parity bits
        code_out[16] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[12] ^ data_in[14]; // P1
        code_out[17] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6] ^ data_in[8] ^ data_in[10] ^ data_in[13] ^ data_in[14]; // P2
        code_out[18] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7] ^ data_in[8] ^ data_in[10] ^ data_in[11] ^ data_in[13] ^ data_in[15]; // P4
        code_out[19] = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7] ^ data_in[8] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15]; // P8
        code_out[20] = data_in[8] ^ data_in[9] ^ data_in[10] ^ data_in[11] ^ data_in[12] ^ data_in[13] ^ data_in[14] ^ data_in[15]; // P16
    end
endmodule