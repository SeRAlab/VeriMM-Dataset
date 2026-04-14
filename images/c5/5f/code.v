module parity_generator (
    input [3:0] in,
    output parity
);

assign parity = ^in;

endmodule