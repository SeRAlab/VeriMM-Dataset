module odd_parity_generator (
    input [3:0] data,
    output parity
);
    assign parity = ~^data; // Odd parity: parity is 1 if number of 1's is odd
endmodule