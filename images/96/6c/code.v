module top_module(
    X   ,
    A0  ,
    A1  ,
    A2  ,
    A3  ,
    S0  ,
    S1  ,
    VPWR,
    VGND
);output X   ;
    input  A0  ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  S0  ;
    input  S1  ;
    input  VPWR;
    input  VGND;

    assign X = (~S1 & ~S0 & A0) | (~S1 & S0 & A1) | (S1 & ~S0 & A2) | (S1 & S0 & A3);

endmodule