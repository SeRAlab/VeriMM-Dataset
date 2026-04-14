module top_module(
    HI  ,
    LO  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output HI;
    output LO;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    wire HI_temp;
    wire LO_temp;

    assign HI = HI_temp;
    assign LO = LO_temp;

    assign HI_temp = (VPWR && !VPB) ? 1'b1 : ((VGND || !VPWR || VPB) ? 1'b0 : HI_temp);
    assign LO_temp = (!VPWR && !VNB) ? 1'b1 : ((VGND || VPWR || VNB) ? 1'b0 : LO_temp);

endmodule