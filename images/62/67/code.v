module top_module(G2, Pr2, G3, Pr3);input [15:0]G2;
    input [15:0]Pr2;
    output [15:0]G3;
    output [15:0]Pr3;
    
    assign G3[15:0] = G2[15:0] | Pr2[15:0] & {G2[11:0],G2[15:12]} ;
    assign Pr3[15:0] = Pr2[15:0] & {Pr2[11:0],Pr2[15:12]} ;endmodule