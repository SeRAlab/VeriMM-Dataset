module top_module(
    X    ,
    A    ,
    B    ,
    sel  ,
    VPWR ,
    VGND
);output X   ;
    input  A   ;
    input  B   ;
    input  sel ;
    input  VPWR;
    input  VGND;

    wire sel_inv;
    assign sel_inv = ~sel;

    assign X = (sel & B) | (sel_inv & A);

endmodule