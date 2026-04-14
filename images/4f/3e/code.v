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
    wire xnor0_out;
    wire xnor1_out;
    wire xnor2_out;

    //   Name   Output       Other arguments
    xnor xnor0 (xnor0_out, A, B, C);
    xnor xnor1 (xnor1_out, B, C, D);
    xnor xnor2 (xnor2_out, A, C, D);
    buf  buf0  (X         , xnor0_out);
    xnor xnor3 (X         , xnor1_out, xnor2_out, D);

endmodule