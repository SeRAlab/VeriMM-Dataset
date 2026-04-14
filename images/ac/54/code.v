module top_module(
    input A,
    input B,
    input C,
    output X,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);assign X = A & B & C;

endmodule