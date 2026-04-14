module even_parity_generator(
    input [n-1:0] data_in,
    output parity_out
);
    parameter n = 8; // Change n for different input sizes
    assign parity_out = ~(^data_in); // Even parity: output is 0 if count of 1's is even
endmodule