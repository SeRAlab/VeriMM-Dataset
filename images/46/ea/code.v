module top_module(
    input  A1,
    input  A2,
    input  B1,
    input  C1,
    input  D1,
    output Y
);assign Y = ((A1 & A2) | (B1 & C1)) ? 1'b1 : (D1 ? 1'b0 : 1'b1);

endmodule