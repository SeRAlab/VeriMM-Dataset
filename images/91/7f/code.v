module top_module(
    input  wire [3:0] x0,
    input  wire [3:0] x1,
    input  wire [3:0] x2,
    input  wire [3:0] x3,
    input  wire [3:0] x4,
    input  wire [3:0] x5,
    input  wire [3:0] x6,
    input  wire [3:0] x7,
    input  wire [3:0] x8,
    input  wire [3:0] x9,
    input  wire [3:0] xA,
    input  wire [3:0] xB,
    input  wire [3:0] xC,
    input  wire [3:0] xD,
    input  wire [3:0] xE,
    input  wire [3:0] xF,
    output wire [63:0] r
);assign r = {xF, xE, xD, xC, xB, xA, x9, x8, x7, x6, x5, x4, x3, x2, x1, x0};endmodule