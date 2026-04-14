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

    assign HI = (VPWR && !VPB) ? 1'b1 : 1'b0;
    assign LO = (VGND && !VNB) ? 1'b1 : 1'b0;

endmodule