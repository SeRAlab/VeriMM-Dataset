module bitwise_module(
    input A1,
    input A2,
    input A3,
    input B1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output out
);

wire and1, and2, or1, xor1, or2;

assign and1 = A1 & A2;
assign and2 = A3 & B1;
assign or1 = and1 | and2;
assign xor1 = VPWR ^ VGND;
assign or2 = VPB | VNB;

assign out = or1 & xor1 & or2;

endmodule