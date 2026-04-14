module odd_parity_generator (
    input [N-1:0] data,
    output parity
);
    parameter N = 5; // You can change N to any desired value
    assign parity = ~^data; // XOR reduction to determine parity
endmodule