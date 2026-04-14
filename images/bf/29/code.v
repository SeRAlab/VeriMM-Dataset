module top_module(
    X   ,
    A   ,
    B   ,
    C   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);// Module ports
    output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    // Local signals
    wire or0_out_X        ;
    wire pwrgood_pp0_out_X;

    // Implement OR gate
    or or0 (or0_out_X, B, A, C);

    // Implement power-good signal generator
    assign pwrgood_pp0_out_X = ((VPWR - VGND) >= VPB) && ((VPWR - VGND) <= VNB);

    // Implement buffer
    buf buf0 (X, pwrgood_pp0_out_X);

endmodule