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
    
    wire A_bar;
    
    assign A_bar = ~A;
    
    assign Y = A_bar;
    
endmodule