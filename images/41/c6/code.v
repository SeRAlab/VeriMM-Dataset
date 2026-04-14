module top_module(
    input A,
    input B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output COUT,
    output SUM
);assign SUM = A ^ B;
assign COUT = A & B;

endmodule