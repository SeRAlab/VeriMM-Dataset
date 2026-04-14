module top_module(
    input  A1,
    input  A2,
    input  A3,
    input  B1,
    input  VPWR,
    output Y
);assign Y = (A1 && A2) || (A3 && !B1) ? 1'b1 : (VPWR ? 1'b0 : 1'b0);

endmodule