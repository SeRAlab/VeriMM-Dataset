module or2 (
    output X,
    input A,
    input B_N
);

    assign X = A | ~B_N;

endmodule

module sky130_fd_sc_lp__or2b_2 (
    X   ,
    A   ,
    B_N ,
    VPWR,
    VGND,
    VPB ,
    VNB
);

    output X   ;
    input  A   ;
    input  B_N ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire X_internal;
    
    or2 or2_inst (
        .X(X_internal),
        .A(A),
        .B_N(B_N)
    );
    
    assign X = X_internal;

endmodule