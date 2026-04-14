module top_module(
    Y   ,
    A1_N,
    A2_N,
    B1  ,
    B2
);// Module ports
    output Y   ;
    input  A1_N;
    input  A2_N;
    input  B1  ;
    input  B2  ;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire and0_out  ;
    wire nor0_out  ;
    wire nor1_out_Y;

    //  Name  Output      Other arguments
    and and0 (and0_out  , B1, B2            );
    nor nor0 (nor0_out  , A1_N, A2_N        );
    nor nor1 (nor1_out_Y, nor0_out, and0_out);
    buf buf0 (Y         , nor1_out_Y        );

endmodule