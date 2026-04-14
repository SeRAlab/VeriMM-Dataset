module hamming_encoder (
    input [3:0] data_in,
    output reg [6:0] encoded_out
);
    always @(*) begin
        // Assign data bits
        encoded_out[2] = data_in[0];
        encoded_out[4] = data_in[1];
        encoded_out[5] = data_in[2];
        encoded_out[6] = data_in[3];
        
        // Calculate parity bits
        encoded_out[0] = data_in[0] ^ data_in[1] ^ data_in[3]; // P1
        encoded_out[1] = data_in[0] ^ data_in[2] ^ data_in[3]; // P2
        encoded_out[3] = data_in[1] ^ data_in[2] ^ data_in[3]; // P4
    end
endmodule