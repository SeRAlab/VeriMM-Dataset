module top_module(
    Y,
    A,
    B,
    C
);output Y;
    input  A;
    input  B;
    input  C;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire not_C;
    wire and_AB;

    // Using native Verilog gate primitives instead of unknown modules
    not U1(not_C, C);
    and U2(and_AB, A, B);
    or U3(Y, and_AB, not_C);

endmodule