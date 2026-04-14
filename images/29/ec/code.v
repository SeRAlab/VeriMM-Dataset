module odd_parity_generator(
    input [3:0] data,
    output parity
);
    assign parity = ~^data; // Odd parity for 4-bit input
endmodule