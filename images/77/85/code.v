module top_module(
    input D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Q,
    input GATE_N
);wire D_0;
wire VPWR_1;
wire VGND_1;
wire VPB_1;
wire VNB_1;
wire Q_0;
wire Q_1;

assign D_0 = (D == 1'b0);
assign VPWR_1 = (VPWR == 1'b1);
assign VGND_1 = (VGND == 1'b1);
assign VPB_1 = (VPB == 1'b1);
assign VNB_1 = (VNB == 1'b1);

and and_gate_1 (Q_0, D_0, VPWR_1, VGND_1, VPB_1, VNB_1);
and and_gate_2 (Q_1, ~D_0, ~VPWR_1, ~VGND_1, ~VPB_1, ~VNB_1);

assign Q = (GATE_N == 1'b0) ? Q : ((GATE_N == 1'b1) ? Q_1 : Q_0);

endmodule