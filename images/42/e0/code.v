module top_module(
    Y  ,
    A  ,
    B  ,
    C_N
);output Y  ;
    input  A  ;
    input  B  ;
    input  C_N;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // NOR gate
    assign Y = ~(A | B | C_N);

endmodule