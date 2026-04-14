module top_module(G2, Pr2, G3);input [31:0]G2;
    input [31:0]Pr2;
    output [31:0]G3;
    
    assign G3[31:0] =   G2[31:0] | 
                        Pr2[31:0] & {G2[23:0],G2[31:24]} | 
                        Pr2[31:0] & {Pr2[23:0],Pr2[31:24]} & {G2[15:0],G2[31:16]} |
                        Pr2[31:0] & {Pr2[23:0],Pr2[31:24]} & {Pr2[15:0],Pr2[31:16]} & {G2[7:0],G2[31:8]} ;endmodule