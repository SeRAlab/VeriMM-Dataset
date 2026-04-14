module top_module(
    //# {{data|Data Signals}}
    input  A   ,
    input  B   ,
    input  C_N ,
    output Y   ,

    //# {{power|Power}}
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);// Implement the NOR3B module here
    assign Y = ~(A | B | C_N);

endmodule