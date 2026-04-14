module top_module(
    X   ,
    A1  ,
    A2  ,
    B1  ,
    C1  ,
    D1  ,
    VPWR,
    VGND
);output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  C1  ;
    input  D1  ;
    input  VPWR;
    input  VGND;

    wire and_output;
    wire or_output;
    wire xor_output;

    assign and_output = A1 & A2;
    assign or_output = B1 | C1;
    assign xor_output = D1 ^ VPWR;

    assign X = and_output;

    assign A1 = xor_output;
    assign D1 = or_output;

endmodule