module top_module(
    Y  ,
    A  ,
    B  ,
    C  ,
    D  
);// Module ports
    output Y  ;
    input  A  ;
    input  B  ;
    input  C  ;
    input  D  ;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire nor0_out  ;
    wire nor1_out  ;
    wire nor2_out  ;
    wire and0_out_Y;

    //  Name  Output      Other arguments
    nor nor0 (nor0_out  , A, B);
    nor nor1 (nor1_out  , C, D);
    nor nor2 (nor2_out  , nor0_out, nor1_out);
    buf buf0 (Y         , and0_out_Y        );

endmodule