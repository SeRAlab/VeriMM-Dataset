module top_module(
    X   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    C1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  C1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire cond1, cond2, cond3, cond4, cond5, cond6, cond7;

    assign cond1 = (A1 == 1) && (A2 == 0) && (A3 == 1);
    assign cond2 = (A1 == 0) && (A2 == 1) && (A3 == 0);
    assign cond3 = (A1 == 1) && (A2 == 1) && (A3 == 0);
    assign cond4 = (A1 == 0) && (A2 == 0) && (A3 == 1);
    assign cond5 = (B1 == 1) && (C1 == 0);
    assign cond6 = (B1 == 0) && (C1 == 1);
    assign cond7 = (VPWR == 1) && (VGND == 0) && (VPB == 1) && (VNB == 0);

    assign X = cond1 || cond2 || cond3 || cond5 || cond7 ? 1'b1 :
                cond4 || cond6 ? 1'b0 : 1'b0;

endmodule