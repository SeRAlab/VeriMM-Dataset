module top_module(
    Y   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);// Module ports
    output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    // Local signals
    wire nand0_out_Y      ;
    wire nand1_out_Y      ;
    wire nand2_out_Y      ;

    //                                 Name         Output             Other arguments
    nand                               nand0       (nand0_out_Y      , A, B, VPB, VNB       );
    nand                               nand1       (nand1_out_Y      , C, D, VPB, VNB       );
    nand                               nand2       (Y                , nand0_out_Y, nand1_out_Y, VPB, VNB);

endmodule