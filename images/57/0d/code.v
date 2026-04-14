module top_module(
    input  wire [63:0] x,
    input  wire [79:0] k,
    output wire [63:0] r
);assign r = x ^ k[79:16];endmodule