module rs_encoder (
    input [3:0] data_in, // 4 input symbols
    output [6:0] codeword // 7 output symbols
);
    assign codeword[0] = data_in[0]; // Simple straight mapping for illustration
    assign codeword[1] = data_in[1];
    assign codeword[2] = data_in[2];
    assign codeword[3] = data_in[3];
    assign codeword[4] = data_in[0] ^ data_in[1]; // Example of parity symbol
    assign codeword[5] = data_in[2] ^ data_in[3];
    assign codeword[6] = data_in[0] ^ data_in[2] ^ data_in[3]; // Extra parity
endmodule