module top_module(
    output X,
    input A0,
    input A1,
    input S,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);assign X = S ? A1 : A0;
endmodule