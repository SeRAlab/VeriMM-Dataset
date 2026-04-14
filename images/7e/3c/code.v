module top_module(
    A,
    B,
    X
);// Module ports
    input  A;
    input  B;
    output X;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Internal signal
    wire X_internal;

    // Bitwise OR implementation
    assign X_internal = ~(~A & ~B);
    assign X = X_internal;

endmodule