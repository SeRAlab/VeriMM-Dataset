module top_module(Sel,Write_Byte_En,S0,S1,S2,S3,S4,S5,S6,S7,out);input [3:0] Sel; 
 input [3:0] Write_Byte_En; 
 input [3:0] S0,S1,S2,S3,S4,S5,S6,S7; 
 output [3:0] out; 
 assign out = (Sel[3])?Write_Byte_En:((Sel[2])? (Sel[1]?(Sel[0]?S7:S6) : (Sel[0]?S5:S4)) : (Sel[1]?(Sel[0]?S3:S2) : (Sel[0]?S1:S0))); 
 endmodule