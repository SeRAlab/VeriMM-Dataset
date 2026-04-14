module top_module(
    X  ,
    A  ,
    B  ,
    C  ,
    D_N
);// Module ports
    output X  ;
    input  A  ;
    input  B  ;
    input  C  ;
    input  D_N;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire not0_out ;
    wire nor0_out_X;

    //  Name  Output     Other arguments
    not not0 (not0_out , D_N              );
    nor nor0  (nor0_out_X, A, B, C, not0_out);
    buf buf0  (X        , nor0_out_X      );

endmodule