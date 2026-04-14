module top_module(
    input A1, A2, B1, B2, VPWR, VGND,
    output X
);assign X = (A1 | A2) & (~B1 | B2) & (~A1 | ~A2 | B1);

endmodule