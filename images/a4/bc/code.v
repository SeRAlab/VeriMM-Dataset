module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    output X
);assign X = (A1 & A2 & A3) ? 1 : (B1 ? 0 : 0);

endmodule