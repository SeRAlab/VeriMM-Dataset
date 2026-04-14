module top_module(
    input [3:0] in,
    output [15:0] out
);assign out = ~(1 << in);

endmodule