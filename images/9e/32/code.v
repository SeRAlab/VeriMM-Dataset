module top_module(
    input in_VPWR,
    input in_VGND,
    input in_VPB,
    input in_VNB,
    output out_VPWR,
    output out_VGND,
    output out_VPB,
    output out_VNB
);assign out_VPWR = in_VPWR;
assign out_VGND = in_VGND;
assign out_VPB = in_VPB;
assign out_VNB = in_VNB;

endmodule