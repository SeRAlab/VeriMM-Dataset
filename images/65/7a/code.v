module top_module(
    Y   ,
    A   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire inv1, inv2, inv3;
    
    assign inv1 = ~A;
    assign inv2 = ~inv1;
    assign inv3 = ~inv2;
    
    assign Y = inv3;
    
endmodule