module top_module(
    VPWR,
    VGND,
    VPB ,
    VNB
);input VPWR;
    input VGND;
    output VPB ;
    output VNB ;

    assign VPB = (VPWR <= 5) ? VPWR : 5;
    assign VNB = (VGND >= 0) ? VGND : 0;

endmodule