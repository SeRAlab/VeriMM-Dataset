module top_module(
    //# {{data|Data Signals}}
    input  A1  ,
    input  A2  ,
    input  B1  ,
    output Y   ,

    //# {{power|Power}}
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);assign Y = (A1 ^ A2) ? ~B1 : (A1 & A2) ? B1 : A1 & A2;
    
endmodule