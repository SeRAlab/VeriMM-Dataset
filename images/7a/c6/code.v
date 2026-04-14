module top_module(
    input A1, A2, A3, B1, C1, VPWR, VGND, VPB, VNB,
    output X
);assign X = (A1 & A2 & A3 & B1 & C1 & VPWR & VGND & VPB & VNB) ? 1'b1 : 1'b0;

endmodule