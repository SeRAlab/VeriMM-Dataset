module top_module(
    VPWR,
    VGND,
    VPB ,
    VNB
);input VPWR;
    input VGND;
    input VPB ;
    input VNB ;
    
    wire out;
    
    assign out = (VPB) ? VPWR : (VNB) ? VGND : 1'b0;
    
    assign out = (VPWR || VGND) ? 1'b0 : out;
    
endmodule