module top_module(
    output X,
    input A1,
    input A2,
    input B1_N,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);assign X = (A1 & A2) ? 1'b1 :
               (!B1_N) ? 1'b0 :
               (VPWR & !VGND) ? 1'b1 :
               (VPB & !VNB) ? 1'b0 :
               1'b1;

endmodule