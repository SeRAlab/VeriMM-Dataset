module hamming_encoder (
    input [3:0] data_in,
    output [6:0] encoded_out
);
    assign encoded_out[0] = data_in[0]; // d0
    assign encoded_out[1] = data_in[1]; // d1
    assign encoded_out[2] = data_in[2]; // d2
    assign encoded_out[3] = data_in[3]; // d3

    // Calculate parity bits
    assign encoded_out[4] = data_in[0] ^ data_in[1] ^ data_in[3]; // p1
    assign encoded_out[5] = data_in[0] ^ data_in[2] ^ data_in[3]; // p2
    assign encoded_out[6] = data_in[1] ^ data_in[2] ^ data_in[3]; // p3
endmodule