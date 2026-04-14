module top_module(G4, Pr4, G5);input [31:0]G4;
    input [31:0]Pr4;
    output [31:0]G5;
    
    assign G5[31:0] = G4[31:0] | Pr4[31:0] & {G4[15:0],G4[31:16]} ;endmodule