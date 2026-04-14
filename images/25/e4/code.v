module even_parity_generator(
    input [7:0] data_in,
    output parity
);
    assign parity = ~^data_in; // Even parity calculation
endmodule