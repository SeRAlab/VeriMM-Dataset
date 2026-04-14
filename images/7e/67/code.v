module top_module(
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    C1  ,
    D1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  C1  ;
    input  D1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire cond1, cond2, cond3, cond4, cond5, cond6, cond7;

    assign cond1 = (A1 == 1) && (A2 == 0);
    assign cond2 = (A1 == 0) && (A2 == 1);
    assign cond3 = (B1 == 1) && (C1 == 0) && (D1 == 0);
    assign cond4 = (B1 == 0) && (C1 == 1) && (D1 == 0);
    assign cond5 = (B1 == 0) && (C1 == 0) && (D1 == 1);
    assign cond6 = (VPWR == 0) || (VGND == 1);
    assign cond7 = (VPB == 1) && (VNB == 0);

    assign Y = (cond1 || cond2 || cond3 || cond4 || cond5) && !cond6 || cond7;

endmodule