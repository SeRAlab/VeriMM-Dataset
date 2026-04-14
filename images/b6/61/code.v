module top_module(
    Y,
    A,
    B,
    C,
    D
);// Module ports
    output Y;
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
    wire nand0_out_Y;
    wire nand1_out_Y;
    wire nand2_out_Y;
    wire nand3_out_Y;
    wire nand4_out_Y;
    wire nand5_out_Y;
    wire nand6_out_Y;

    //   Name   Output       Other arguments
    nand nand0 (nand0_out_Y, A, B, C        );
    nand nand1 (nand1_out_Y, B, C, D        );
    nand nand2 (nand2_out_Y, A, B, D        );
    nand nand3 (nand3_out_Y, A, C, D        );
    nand nand4 (nand4_out_Y, nand0_out_Y, nand1_out_Y, nand2_out_Y);
    nand nand5 (nand5_out_Y, nand0_out_Y, nand1_out_Y, nand3_out_Y);
    nand nand6 (Y         , nand4_out_Y, nand5_out_Y);

endmodule