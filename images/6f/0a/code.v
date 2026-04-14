module top_module(
    //# {{data|Data Signals}}
    input  A_N ,
    input  B_N ,
    input  C   ,
    input  D   ,
    output Y   ,

    //# {{power|Power}}
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);// Implement NAND gate logic
    assign Y = ~(A_N & B_N & C & D);

endmodule