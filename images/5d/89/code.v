module top_module(
    input A,
    input B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output X
);assign X = (A | B);

endmodule