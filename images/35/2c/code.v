module even_parity_generator (
    input [4:0] data_in,
    output parity_out
);
    // Parity calculation: XOR all bits together
    assign parity_out = ~(data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4]);
endmodule