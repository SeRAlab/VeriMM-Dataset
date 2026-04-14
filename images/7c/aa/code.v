module top_module(
    //# {{data|Data Signals}}
    input  A1  ,
    input  A2  ,
    input  A3  ,
    input  B1  ,
    input  C1  ,
    output X   ,

    //# {{power|Power}}
    input  VPWR,
    input  VGND
);wire temp1, temp2;
    
    assign temp1 = B1 ? (A1 | A2) : 1'b0;
    assign temp2 = ~B1 & C1 ? (A2 & A3) : 1'b0;
    
    assign X = temp1 ^ temp2 ^ (~B1 & ~C1 ? A1 ^ A2 ^ A3 : 1'b0);

endmodule