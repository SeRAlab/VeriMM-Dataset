module top_module(G2, Pr2, G3, Pr3);input [31:0]G2;
    input [31:0]Pr2;
    output [31:0]G3;
    output [31:0]Pr3;
    
    assign G3[31:0] = G2[31:0] | Pr2[31:0] & {G2[27:0],G2[31:28]} ;
    assign Pr3[31:0] = Pr2[31:0] & {Pr2[27:0],Pr2[31:28]} ;endmodule