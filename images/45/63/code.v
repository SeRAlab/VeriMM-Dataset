module top_module(
    VPWR,
    VGND,
    VPB,
    VNB,
    VPB_OUT,
    VNB_OUT,
    VPWR_OUT,
    VGND_OUT
);input VPWR;
    input VGND;
    input VPB;
    input VNB;
    output VPB_OUT;
    output VNB_OUT;
    output VPWR_OUT;
    output VGND_OUT;

    assign VPWR_OUT = VPWR;
    assign VGND_OUT = VGND;

    assign VPB_OUT = (VPB == 1'b1) ? VPWR : VGND;
    assign VNB_OUT = (VNB == 1'b1) ? VPWR : VGND;

endmodule