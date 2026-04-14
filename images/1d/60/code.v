module hamming_encoder(
    input [7:0] data_in,
    output [11:0] encoded_out
);
    wire p1, p2, p3, p4;

    assign p1 = data_in[0] ^ data_in[1] ^ data_in[3] ^ data_in[4] ^ data_in[6];
    assign p2 = data_in[0] ^ data_in[2] ^ data_in[3] ^ data_in[5] ^ data_in[6];
    assign p3 = data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[7];
    assign p4 = data_in[4] ^ data_in[5] ^ data_in[6] ^ data_in[7];

    assign encoded_out[11] = p1;
    assign encoded_out[10] = p2;
    assign encoded_out[9]  = p3;
    assign encoded_out[8]  = p4;
    assign encoded_out[7:0] = data_in;

endmodule