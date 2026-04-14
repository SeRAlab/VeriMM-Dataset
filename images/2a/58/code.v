module hamming_encoder (
    input [3:0] data_in,
    output reg [6:0] code_out
);
    always @(*) begin
        // Assigning values to code_out based on the Hamming (7,4) encoding scheme
        code_out[0] = data_in[0]; // d0
        code_out[1] = data_in[1]; // d1
        code_out[2] = data_in[2]; // d2
        code_out[3] = data_in[3]; // d3
        // Calculate parity bits
        code_out[4] = data_in[0] ^ data_in[1] ^ data_in[3]; // p1
        code_out[5] = data_in[0] ^ data_in[2] ^ data_in[3]; // p2
        code_out[6] = data_in[1] ^ data_in[2] ^ data_in[3]; // p3
    end
endmodule