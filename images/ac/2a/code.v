module top_module(
    Y   ,
    A   ,
    B   ,
    C_N ,
    VPWR,
    VGND
);output Y   ;
    input  A   ;
    input  B   ;
    input  C_N ;
    input  VPWR;
    input  VGND;

    wire  n1, n2, n3, n4;

    // Changed the module instance from sky130_fd_sc_lp__nor3b to an equivalent logic implementation
    assign n1 = ~(A | B | C_N);

    assign n2 = ~n1;
    assign n3 = ~C_N;
    assign n4 = n2 & n3;
    assign Y = ~n4;

endmodule