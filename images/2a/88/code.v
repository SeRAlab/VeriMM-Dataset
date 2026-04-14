module parity_checker (
    input [3:0] data,
    output parity
);
    assign parity = ~^data; // Even parity (1 for even number of 1's, 0 for odd)
endmodule