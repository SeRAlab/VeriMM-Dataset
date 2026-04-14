module top_module(
    input  A1,
    input  A2,
    input  A3,
    input  B1,
    output X
);assign X = (A1 & A2) | (~A1 & A3 & B1) | (~A1 & ~A3 & (A2 & B1));

endmodule