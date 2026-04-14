module top_module(
    input A,
    input B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Y
);assign Y = !(A & B);

endmodule