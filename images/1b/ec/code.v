module odd_parity_generator(
    input [4:0] data,
    output parity
);
    assign parity = ~^data; // Odd parity: output is 1 if the count of 1's is odd
endmodule