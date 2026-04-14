module parity_checker (
    input [4:0] data_in,
    output parity_out
);
    assign parity_out = ~^data_in; // Even parity: 1 if even number of 1s
endmodule