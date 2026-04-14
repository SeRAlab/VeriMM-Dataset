module top_module(A,B,C,S,Co);input A;
input B;
input C;
output S;
output Co;
	

assign #1 S = A ^ B ^ C;
assign #0.5 Co = (A & B) | (B & C) | (A & C);endmodule