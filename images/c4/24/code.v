module sky130_fd_sc_ls__a211oi (
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    C1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  C1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    assign Y = (A1 & A2) | ((!A1) & (!A2) & B1 & (!C1)) | ((!A1) & (!A2) & (!B1) & C1);

endmodule