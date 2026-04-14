module top_module(Sel,S0,S1,S2,S3,S4,S5,S6,S7,ALU_out);input [2:0] Sel;
input [31:0] S0,S1,S2,S3,S4,S5,S6,S7;
output [31:0]ALU_out;

assign ALU_out = (Sel[2])? (Sel[1]?(Sel[0]?S7:S6) : (Sel[0]?S5:S4))  :  (Sel[1]?(Sel[0]?S3:S2) : (Sel[0]?S1:S0));

endmodule