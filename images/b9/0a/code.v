module parity_generator (
    input [3:0] in,
    output parity
);

    assign parity = in[0] ^ in[1] ^ in[2] ^ in[3];

endmodule