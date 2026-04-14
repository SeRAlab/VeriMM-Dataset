module even_parity_generator (
    input [7:0] data_in,
    output parity_out
);
    assign parity_out = ~^data_in; // Even parity: invert the XOR of all bits
endmodule