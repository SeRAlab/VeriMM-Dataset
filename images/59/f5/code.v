module top_module(
    input A,
    input B,
    input S,
    output Y,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);assign Y = (!S & A) | (S & B);
endmodule