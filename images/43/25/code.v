module top_module(
    input [3:0] in,
    output parity
);assign parity = ^in;

endmodule