module top_module(
    X   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    B2  ,
    VPWR,
    VGND
);output X   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;

    assign X = ((A1 & A2 & A3) | (B1 & B2)) & (VPWR & VGND);

endmodule