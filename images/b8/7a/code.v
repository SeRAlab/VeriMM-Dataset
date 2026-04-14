module top_module(
    Y  ,
    A  ,
    B  ,
    C_N,
    D_N
);output Y  ;
    input  A  ;
    input  B  ;
    input  C_N;
    input  D_N;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign Y = ~(A | B | C_N | D_N);

endmodule