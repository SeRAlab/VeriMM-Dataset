module top_module(Sel,S0,S1,S2,S3,S4,S5,S6,S7,out);input [2:0] Sel;
input [7:0] S0,S1,S2,S3,S4,S5,S6,S7;
output [7:0]out;

assign out = (Sel[2])? (Sel[1]?(Sel[0]?S7:S6) : (Sel[0]?S5:S4))  :  (Sel[1]?(Sel[0]?S3:S2) : (Sel[0]?S1:S0));

endmodule