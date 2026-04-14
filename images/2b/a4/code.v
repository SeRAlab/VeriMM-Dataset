module odd_parity_generator(
    input [3:0] data_in,
    output parity_out
);
    assign parity_out = ^data_in; // XOR reduction to check for odd parity
endmodule