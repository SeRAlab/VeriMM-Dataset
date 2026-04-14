module top_module(
    input A,
    input SLEEP,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output X
);wire VPWR_inverted;
    wire VPB_inverted;
    wire VNB_inverted;

    assign VPWR_inverted = (A == 1'b1) ? ~VPWR : VPWR;
    assign VPB_inverted = (SLEEP == 1'b1) ? ~VPB : VPB;
    assign VNB_inverted = (VGND == 1'b1) ? ~VNB : VNB;

    assign X = {VPWR_inverted, VPB_inverted, VNB_inverted};

endmodule