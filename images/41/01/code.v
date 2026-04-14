module even_parity_generator (
    input [3:0] data,
    output parity
);
    assign parity = ~(^data); // Even parity: output '1' if even number of '1's
endmodule