module sky130_fd_sc_lp__o21a (
    X   ,
    A1  ,
    A2  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire a1_high, a1_low_a2_high, a1_a2_low_b1_high;
    
    assign a1_high = (A1 == 1'b1);
    assign a1_low_a2_high = (A1 == 1'b0) && (A2 == 1'b1);
    assign a1_a2_low_b1_high = (A1 == 1'b0) && (A2 == 1'b0) && (B1 == 1'b1);
    
    assign X = a1_high || a1_low_a2_high || a1_a2_low_b1_high;
    
endmodule