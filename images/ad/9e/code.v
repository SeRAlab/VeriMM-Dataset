module top_module(
    X,
    A,
    B,
    C
);// Module ports
    output X;
    input  A;
    input  B;
    input  C;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire or0_out_X;

    // OR gate implementation
    or or0_1 (or0_out_X, A, B);
    or or0_2 (or0_out_X, or0_out_X, C);

    // Buffer implementation
    buf buf0 (X, or0_out_X);

endmodule