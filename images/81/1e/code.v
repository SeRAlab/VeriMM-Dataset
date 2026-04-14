module top_module(
    Y  ,
    A  ,
    B  ,
    C  ,
    D_N
);// Module ports
    output Y  ;
    input  A  ;
    input  B  ;
    input  C  ;
    input  D_N;

    // Local signals
    wire not0_out  ;
    wire nor0_out_Y;

    //  Name  Output      Other arguments
    not not0 (not0_out  , D_N              );
    nor nor0 (nor0_out_Y, A, B, C, not0_out);
    buf buf0 (Y         , nor0_out_Y       );

endmodule