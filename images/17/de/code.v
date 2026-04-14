module even_parity_generator (
    input [3:0] data_in,
    output parity_out
);

assign parity_out = ~(^data_in); // Even parity: Output 0 if even number of 1's, 1 if odd number of 1's

endmodule