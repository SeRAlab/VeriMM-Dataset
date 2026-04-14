module top_module(
    //# {{data|Data Signals}}
    input  A   ,
    input  B_N ,
    output X   ,

    //# {{power|Power}}
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);assign X = A | ~B_N;

endmodule