module top_module(
input A,B,
output S,Co
);assign S	= A^B;
	assign Co	= A&B;endmodule