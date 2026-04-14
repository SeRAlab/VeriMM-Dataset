module top_module(
    //# {{data|Data Signals}}
    input  A1  ,
    input  A2  ,
    input  B1  ,
    output X   ,

    //# {{power|Power}}
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);wire temp1, temp2, temp3, temp4;
    assign temp1 = ~(A1 & A2);
    assign temp2 = A1 ^ B1;
    assign temp3 = ~B1;
    assign temp4 = A1;
    assign X = temp1 & temp2 | temp3 & temp4;
endmodule