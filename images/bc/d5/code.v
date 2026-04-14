module top_module(
    Z   ,
    A   ,
    TE_B,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Z   ;
    input  A   ;
    input  TE_B;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire nand_out, nor_out;

    assign nand_out = ~(A & TE_B);
    assign nor_out = ~(A | TE_B);

    assign Z = (VPWR & nor_out) | (VGND & nand_out);

endmodule