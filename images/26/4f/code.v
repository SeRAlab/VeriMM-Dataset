module rs_encoder(
    input [3:0] data_in,
    output reg [6:0] encoded_out
);
    
    // Simple Reed-Solomon encoding logic
    always @(*) begin
        encoded_out[6:4] = data_in; // Copy 4 bits of data
        encoded_out[3] = data_in[0] ^ data_in[1] ^ data_in[2]; // Simple parity check
        encoded_out[2] = data_in[1] ^ data_in[2] ^ data_in[3]; // Simple parity check
        encoded_out[1] = data_in[0] ^ data_in[2] ^ data_in[3]; // Simple parity check
        encoded_out[0] = data_in[0] ^ data_in[1] ^ data_in[3]; // Simple parity check
    end
endmodule