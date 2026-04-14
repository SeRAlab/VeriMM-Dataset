module top_module(
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    C1  ,
    VPWR
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  C1  ;
    input  VPWR;

    assign Y = (~A1 & ~A2 & ~B1 & ~C1) |
               (~A1 & ~A2 &  B1 &  C1) |
               (~A1 &  A2 & ~B1 &  VPWR) |
               (~A1 &  A2 &  B1 & ~C1) |
               ( A1 & ~A2 & ~B1 &  VPWR) |
               ( A1 & ~A2 &  B1 & ~C1) |
               ( A1 &  A2 &  B1 &  C1);

endmodule