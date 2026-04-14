module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    input D1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output X
);assign X = (A1 == 0 && A2 == 0 && B1 == 0 && C1 == 0 && D1 == 0 && VGND == 0 && VNB == 0 && VPB == 0 && VPWR == 0) ? 1'b0 :
               (A1 == 1 && A2 == 1 && B1 == 1 && C1 == 1 && D1 == 1 && VGND == 1 && VNB == 1 && VPB == 1 && VPWR == 1) ? 1'b1 :
               1'bx;

endmodule