module top_module(
    Y   ,
    A_N ,
    B_N ,
    C   ,
    D   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);// Module ports
    output Y   ;
    input  A_N ;
    input  B_N ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    // Local signals
    wire nand0_out        ;
    wire nand1_out        ;
    wire nand2_out        ;
    wire nand3_out        ;
    wire or0_out_Y        ;
    wire pwrgood_pp0_out_Y;

    //                                 Name         Output             Other arguments
    nand                               nand0       (nand0_out        , D, C                 );
    nand                               nand1       (nand1_out        , B_N, A_N             );
    nand                               nand2       (nand2_out        , nand1_out, nand0_out);
    nand                               nand3       (nand3_out        , nand2_out, nand2_out);
    or                                 or0         (or0_out_Y        , nand3_out, nand3_out);
  
    // Simple power-good behavior assumed as a pass-through for simplification
    assign pwrgood_pp0_out_Y = (VPWR && VGND) ? or0_out_Y : 1'b0;
    
    buf                                buf0        (Y                , pwrgood_pp0_out_Y    );

endmodule