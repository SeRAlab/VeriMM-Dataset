module odd_parity_generator (
    input [3:0] data,
    output parity
);
    assign parity = ~(^data); // Odd parity: 0 if odd number of 1s, 1 if even number of 1s
endmodule