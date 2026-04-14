module top_module(
    input A,
    input B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Y
);assign Y = ~(A | B | VPWR | VGND | VPB | VNB);

endmodule