module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    input B2,
    output X,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);assign X = (A1 & !A2) ? 1'b1 :
               (!A1 & A2) ? 1'b0 :
               (A1 & A2 & !A3 & B1 & !B2) ? 1'b1 :
               (A1 & A2 & !A3 & !B1 & B2) ? 1'b1 :
               1'b0;

endmodule