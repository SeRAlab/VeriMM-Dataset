module top_module(
    Y  ,
    A  ,
    B  ,
    C_N,
    D_N
);// Module ports
    output Y  ;
    input  A  ;
    input  B  ;
    input  C_N;
    input  D_N;

    // Local signals
    wire nor0_out  ;
    wire and0_out_Y;

    //  Name  Output      Other arguments
    nor nor0 (nor0_out  , A, B              );
    and and0 (and0_out_Y, C_N, D_N          );
    buf buf0 (Y         , nor0_out & and0_out_Y);

endmodule