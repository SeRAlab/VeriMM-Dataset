module top_module(G1, Pr1, G2, Pr2);input [15:0]G1;
    input [15:0]Pr1;
    output [15:0]G2;
    output [15:0]Pr2;
    
    assign G2[15:0] = G1[15:0] | Pr1[15:0] & {G1[13:0],G1[15:14]} ;
    assign Pr2[15:0] = Pr1[15:0] & {Pr1[13:0],Pr1[15:14]} ;endmodule