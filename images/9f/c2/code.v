module top_module(
    Y,
    A,
    B,
    C
);// Module ports
    output Y;
    input  A;
    input  B;
    input  C;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire nand1_out_Y;
    wire nand2_out_Y;

    //   Name       Output         Other arguments
    nand nand1     (nand1_out_Y,  A, B, C);
    nand nand2     (nand2_out_Y, nand1_out_Y, C, nand1_out_Y);
    buf  buf0      (Y,            nand2_out_Y);

endmodule