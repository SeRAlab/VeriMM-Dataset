module top_module(
    HI  ,
    LO  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output HI  ;
    output LO  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    assign HI = (VPB == 1'b1 && VNB == 1'b0) ? 1'b1 : 1'b0;
    assign LO = (VPB == 1'b0 && VNB == 1'b1) ? 1'b1 : 1'b0;

endmodule