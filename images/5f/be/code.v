module top_module(
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output wire out_VPWR,
    output wire out_VGND,
    output wire out_VPB,
    output wire out_VNB
);assign out_VGND = VGND;
assign out_VNB = VNB;
assign out_VPB = VPB;

assign out_VPWR = (VPWR == 1'bX) ? 1'b0 : VPWR;

endmodule