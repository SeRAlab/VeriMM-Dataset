module or4b_2 (
    X   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND
);

    output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;

    assign X = A | B | C | D;

endmodule