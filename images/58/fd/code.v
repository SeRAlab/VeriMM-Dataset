module top_module(A, B, score);input [2:0] A,B;
output score;

wire [5:0] decide;

assign decide = {A,B};


assign score=(!decide[5]&!decide[4]&decide[3]&decide[2]&!decide[1]&!decide[0])|
	(!decide[5]&decide[4]&!decide[3]&!decide[2]&!decide[1]&decide[0])|
	(decide[5]&!decide[4]&!decide[3]&!decide[2]&decide[1]&!decide[0]);endmodule