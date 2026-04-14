module hamming_encoder (
    input [7:0] data_in,
    output reg [11:0] encoded_out
);
    always @(*) begin
        // Data bits
        encoded_out[2] = data_in[0];
        encoded_out[4] = data_in[1];
        encoded_out[5] = data_in[2];
        encoded_out[6] = data_in[3];
        encoded_out[8] = data_in[4];
        encoded_out[9] = data_in[5];
        encoded_out[10] = data_in[6];
        encoded_out[11] = data_in[7];

        // Parity bits
        encoded_out[0] = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6]; // P1
        encoded_out[1] = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6]; // P2
        encoded_out[3] = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7];               // P3
        encoded_out[7] = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7];               // P4
    end
endmodule