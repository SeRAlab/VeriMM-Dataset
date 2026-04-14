module gray_to_binary(
    input  [3:0] gray_in,
    output [3:0] binary_out
);

    assign binary_out[3] = gray_in[3];
    assign binary_out[2] = gray_in[3] ^ gray_in[2];
    assign binary_out[1] = binary_out[2] ^ gray_in[1];
    assign binary_out[0] = binary_out[1] ^ gray_in[0];

endmodule