module top_module(
    Y  ,
    A  ,
    B  ,
    C_N
);// Module ports
    output Y  ;
    input  A  ;
    input  B  ;
    input  C_N;

    // Local signals
    wire nor0_out  ;
    wire and0_out_Y;

    //  Name  Output      Other arguments
    nor nor0 (nor0_out  , A, B           );
    and and0 (and0_out_Y, C_N, nor0_out  );
    buf buf0 (Y         , and0_out_Y     );

endmodule