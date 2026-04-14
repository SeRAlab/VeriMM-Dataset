module top_module(G3, Pr3, G4);input [15:0]G3;
    input [15:0]Pr3;
    output [15:0]G4;

    
    assign G4[15:0] = G3[15:0] | Pr3[15:0] & {G3[7:0],G3[15:8]} ;endmodule