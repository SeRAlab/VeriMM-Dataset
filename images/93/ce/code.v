module top_module(
    Y   ,
    A   ,
    B   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A   ;
    input  B   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire A_inv, B_inv, A_B, A_inv_B_inv;
    
    // Invert A and B
    not (A_inv, A);
    not (B_inv, B);
    
    // AND A and B
    and (A_B, A, B);
    
    // AND inverted A and inverted B
    and (A_inv_B_inv, A_inv, B_inv);
    
    // OR the results of the two AND gates
    or (Y, A_B, A_inv_B_inv);

endmodule