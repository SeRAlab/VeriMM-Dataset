module top_module(
    Y   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire A_all_high = (A1 & A2 & A3);
    wire VPB_high = (VPB == 1'b1);
    wire VNB_low = (VNB == 1'b0);
    wire VPB_low = (VPB == 1'b0);
    wire VNB_high = (VNB == 1'b1);
    
    assign Y = (A_all_high | VPWR | (VPB_high & VNB_low)) & !(B1 | VGND | (VPB_low & VNB_high));
    
endmodule