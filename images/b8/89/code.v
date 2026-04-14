module top_module(
    X   ,
    A1  ,
    A2  ,
    B1  ,
    VPWR,
    VGND
);output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  VPWR;
    input  VGND;

    assign X = (A1 & A2 & B1 & VPWR & VGND);

endmodule