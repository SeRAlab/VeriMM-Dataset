module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    input B2,
    output X
);assign X = (A1 & A2 & A3) ? 1'b1 : ((B1 & B2) ? 1'b0 : 1'b1);

endmodule