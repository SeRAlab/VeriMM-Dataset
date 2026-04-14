module top_module(
    //# {{data|Data Signals}}
    input  A1  ,
    input  A2  ,
    input  B1  ,
    input  C1  ,
    output X   ,

    //# {{power|Power}}
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);wire A1_A2;
    wire B1_C1;

    assign A1_A2 = A1 & A2;
    assign B1_C1 = B1 & C1;

    assign X = A1_A2 | B1_C1;

endmodule