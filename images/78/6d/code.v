module top_module(
input A,B,Ci,
output S,Co
);wire exAB	= A^B;
	assign S	= exAB^Ci;
	assign Co	= (A&B)|(exAB&Ci);endmodule