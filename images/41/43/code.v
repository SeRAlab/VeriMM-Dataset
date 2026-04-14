module top_module(
    input A1,
    input A2,
    input B1,
    input VPWR,
    output X,
    output Y,
    output Z,
    output W
);assign X = A1 & A2;
    assign Y = A1 | A2;
    assign Z = A1 ^ A2;
    assign W = B1 & VPWR;

endmodule