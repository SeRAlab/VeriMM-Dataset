module top_module(
    X,
    A,
    B,
    C,
    D
);// Module ports
    output X;
    input  A;
    input  B;
    input  C;
    input  D;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire or0_out_X;

    //  Name  Output     Other arguments
    or  or0  (or0_out_X, D, C, B, A     );
    buf buf0 (X        , or0_out_X      );

endmodule