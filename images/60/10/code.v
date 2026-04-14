module top_module(G1, Pr1, G2);input [15:0]G1;
    input [15:0]Pr1;
    output [15:0]G2;

    
    assign G2[15:0] =   G1[15:0] | 
                        Pr1[15:0] & {G1[11:0],G1[15:12]} |
                        Pr1[15:0] & {Pr1[11:0],Pr1[15:12]} & {G1[7:0],G1[15:8]} | 
                        Pr1[15:0] & {Pr1[11:0],Pr1[15:12]} & {Pr1[7:0],Pr1[15:8]} & {G1[3:0],G1[15:4]} ;endmodule