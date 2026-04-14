module top_module(
    HI,
    LO,
    VPWR,
    VGND,
    VPB,
    VNB
);output HI;
    output LO;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    wire HI_internal;
    wire LO_internal;

    assign HI = HI_internal;
    assign LO = LO_internal;

    assign HI_internal = (VPWR || VPB) ? 1'b1 : (VNB) ? 1'b0 : (VGND) ? 1'b0 : 1'b0;
    assign LO_internal = (VGND || VNB) ? 1'b1 : (VPB) ? 1'b0 : (VPWR) ? 1'b1 : 1'b0;

endmodule